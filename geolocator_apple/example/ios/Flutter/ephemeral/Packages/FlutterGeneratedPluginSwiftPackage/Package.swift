// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "url_launcher_ios", path: "/Users/Alejandro-castillo/.pub-cache/hosted/pub.dev/url_launcher_ios-6.3.2/ios/url_launcher_ios"),
        .package(name: "geolocator_apple", path: "/Users/Alejandro-castillo/Developer/flutter-geolocator/geolocator_apple/darwin/geolocator_apple")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "geolocator-apple", package: "geolocator_apple")
            ]
        )
    ]
)
