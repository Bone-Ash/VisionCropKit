// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "VisionCropKit",
    platforms: [.visionOS(.v1)],
    products: [
        .library(
            name: "VisionCropKit",
            targets: ["VisionCropKit"]),
    ],
    targets: [
        .target(
            name: "VisionCropKit"),
    ]
)
