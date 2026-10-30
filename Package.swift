// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CZPicker",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "CZPicker", targets: ["CZPicker"]),
        .library(name: "CZPickerUI", targets: ["CZPickerUI"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CZPicker", path: "Pod/Classes", exclude: [".gitkeep"], publicHeadersPath: "."),
        .target(name: "CZPickerUI"),
        .testTarget(name: "CZPickerTests", dependencies: ["CZPicker", "CZPickerUI"])
    ]
)
