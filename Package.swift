// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "tca-swift-log",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "TCASwiftLog", targets: ["TCASwiftLog"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-log.git", from: "1.5.2"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "TCASwiftLog",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Logging", package: "swift-log"),
      ]
    ),
    .testTarget(
      name: "TCASwiftLogTests",
      dependencies: [
        .target(name: "TCASwiftLog"),
      ]
    ),
  ]
)
