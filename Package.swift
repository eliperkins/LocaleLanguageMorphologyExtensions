// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "LocaleLanguageMorphologyExtensions",
  platforms: [
    .macOS(.v15),
    .iOS(.v15),
    .watchOS(.v8),
    .tvOS(.v15),
  ],
  products: [
    .library(
      name: "LocaleLanguageMorphologyExtensions",
      targets: ["LocaleLanguageMorphologyExtensions"]
    )
  ],
  targets: [
    .target(
      name: "LocaleLanguageMorphologyExtensions"
    ),
    .testTarget(
      name: "LocaleLanguageMorphologyExtensionsTests",
      dependencies: ["LocaleLanguageMorphologyExtensions"]
    ),
    .executableTarget(name: "GenerateFromCLDR"),
  ]
)
