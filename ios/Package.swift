// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Sofrino",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SofrinoDesignSystem", targets: ["SofrinoDesignSystem"]),
        .library(name: "SofrinoCore", targets: ["SofrinoCore"]),
        .library(name: "SofrinoAuthentication", targets: ["SofrinoAuthentication"]),
        .library(name: "SofrinoApp", targets: ["SofrinoApp"])
    ],
    targets: [
        .target(
            name: "SofrinoDesignSystem",
            path: "Sources/SofrinoDesignSystem"
        ),
        .target(
            name: "SofrinoCore",
            path: "Sources/SofrinoCore"
        ),
        .target(
            name: "SofrinoAuthentication",
            dependencies: ["SofrinoCore", "SofrinoDesignSystem"],
            path: "Sources/SofrinoAuthentication"
        ),
        .target(
            name: "SofrinoApp",
            dependencies: ["SofrinoCore", "SofrinoDesignSystem", "SofrinoAuthentication"],
            path: "Sources/SofrinoApp"
        ),
        .testTarget(
            name: "SofrinoCoreTests",
            dependencies: ["SofrinoCore"],
            path: "Tests/SofrinoCoreTests"
        ),
        .testTarget(
            name: "SofrinoAuthenticationTests",
            dependencies: ["SofrinoAuthentication", "SofrinoCore"],
            path: "Tests/SofrinoAuthenticationTests"
        )
    ]
)
