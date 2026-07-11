import Foundation

/// The single network entry point for the entire app. Every feature
/// repository depends on `HTTPClientProtocol`, never on `URLSession`
/// directly — this is what makes repositories unit-testable and what lets
/// `DemoAuthRepository` (and other demo repositories) exist side-by-side
/// with production ones without any `#if DEBUG` branching in view models.
public protocol HTTPClientProtocol: Sendable {
    func send<Response: Decodable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response
    /// For endpoints that return no body (e.g. 204 No Content).
    func send(_ endpoint: Endpoint) async throws
}

/// A `URLSession`-backed client that talks directly to Supabase's REST and
/// Auth endpoints. Sofrino intentionally does not depend on the Supabase
/// Swift SDK: Auth (`/auth/v1/*`) and PostgREST (`/rest/v1/*`) are plain,
/// well-documented HTTP APIs, and implementing them directly keeps the
/// dependency graph small and every request fully inspectable.
public final class SupabaseHTTPClient: HTTPClientProtocol {
    private let configuration: SupabaseConfiguration
    private let session: URLSession
    private let sessionStore: SessionStoring
    private let reachability: any ReachabilityMonitoring
    private let logger: SofrinoLogger

    public init(
        configuration: SupabaseConfiguration,
        session: URLSession = .shared,
        sessionStore: SessionStoring,
        reachability: any ReachabilityMonitoring,
        logger: SofrinoLogger = .init(category: "networking")
    ) {
        self.configuration = configuration
        self.session = session
        self.sessionStore = sessionStore
        self.reachability = reachability
        self.logger = logger
    }

    public func send<Response: Decodable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response {
        let data = try await sendRaw(endpoint)
        do {
            return try JSONDecoder.sofrinoDefault.decode(Response.self, from: data)
        } catch {
            logger.error("Decoding failed for \(endpoint.path): \(error)")
            throw NetworkError.decoding(String(describing: error))
        }
    }

    public func send(_ endpoint: Endpoint) async throws {
        _ = try await sendRaw(endpoint)
    }

    @discardableResult
    private func sendRaw(_ endpoint: Endpoint) async throws -> Data {
        let isConnected = await MainActor.run { reachability.isConnected }
        guard isConnected else {
            throw NetworkError.offline
        }

        let request = try await buildRequest(for: endpoint)

        do {
            let (data, response) = try await session.data(for: request)
            return try validate(data: data, response: response)
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            throw map(urlError)
        } catch {
            throw NetworkError.unknown(String(describing: error))
        }
    }

    private func buildRequest(for endpoint: Endpoint) async throws -> URLRequest {
        var components = URLComponents(
            url: configuration.projectURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(configuration.anonKey, forHTTPHeaderField: "apikey")

        if endpoint.requiresAuth, let accessToken = await sessionStore.currentSession()?.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            // Unauthenticated requests (send OTP, verify OTP) still need
            // the project anon key as the bearer token per Supabase's API.
            request.setValue("Bearer \(configuration.anonKey)", forHTTPHeaderField: "Authorization")
        }

        for (field, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: field)
        }

        return request
    }

    private func validate(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401, 403:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 429:
            let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After").flatMap(Int.init)
            throw NetworkError.rateLimited(retryAfterSeconds: retryAfter)
        case 400...499:
            throw NetworkError.server(statusCode: httpResponse.statusCode, message: extractMessage(from: data))
        case 500...599:
            throw NetworkError.server(statusCode: httpResponse.statusCode, message: nil)
        default:
            throw NetworkError.unknown("Unexpected status code \(httpResponse.statusCode)")
        }
    }

    /// Supabase's Auth and PostgREST error bodies don't share one schema —
    /// Auth typically returns `{"msg": "..."}` or `{"error_description":
    /// "..."}`, PostgREST returns `{"message": "..."}`. Try all three.
    private func extractMessage(from data: Data) -> String? {
        struct SupabaseErrorBody: Decodable {
            let message: String?
            let errorDescription: String?
            let msg: String?
        }
        guard let body = try? JSONDecoder.sofrinoDefault.decode(SupabaseErrorBody.self, from: data) else {
            return nil
        }
        return body.message ?? body.errorDescription ?? body.msg
    }

    private func map(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .offline
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
