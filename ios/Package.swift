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
        .library(name: "SofrinoCatalog", targets: ["SofrinoCatalog"]),
        .library(name: "SofrinoApp", targets: ["SofrinoApp"])
    ],
    targets: [
        .target(
            name: "SofrinoCore",
            path: "Sources/SofrinoCore"
        ),
        .target(
            name: "SofrinoDesignSystem",
            // Added when the Catalog feature introduced `SofrinoRemoteImage`,
            // which needs `SofrinoImageLoader`'s cache/network pipeline —
            // see docs/sofrino-ios-architecture.md, "Why DesignSystem now
            // depends on Core." SofrinoCore still depends on nothing, so
            // the graph stays an acyclic DAG.
            dependencies: ["SofrinoCore"],
            path: "Sources/SofrinoDesignSystem"
        ),
        .target(
            name: "SofrinoAuthentication",
            dependencies: ["SofrinoCore", "SofrinoDesignSystem"],
            path: "Sources/SofrinoAuthentication"
        ),
        .target(
            name: "SofrinoCatalog",
            dependencies: ["SofrinoCore", "SofrinoDesignSystem"],
            path: "Sources/SofrinoCatalog"
        ),
        .target(
            name: "SofrinoApp",
            dependencies: ["SofrinoCore", "SofrinoDesignSystem", "SofrinoAuthentication", "SofrinoCatalog"],
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
        ),
        .testTarget(
            name: "SofrinoCatalogTests",
            dependencies: ["SofrinoCatalog", "SofrinoCore"],
            path: "Tests/SofrinoCatalogTests"
        )
    ]
)
