// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "geolocator_apple",
    platforms: [
        .iOS("11.0"),
        .macOS("10.11")
    ],
    products: [
        .library(name: "geolocator-apple", targets: ["geolocator_apple"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "geolocator_apple",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: "include/geolocator_apple",
            cSettings: [
                .headerSearchPath("include/geolocator_apple")
            ]
        )
    ]
)
