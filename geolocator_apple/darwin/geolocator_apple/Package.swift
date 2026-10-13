// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

// Opt out of the `requestAlwaysAuthorization` call (avoids ITMS-90683 for
// "when in use"-only apps) — the SPM equivalent of the CocoaPods flag. See #1763.
//   BYPASS_PERMISSION_LOCATION_ALWAYS=1 flutter build ios
// Unset/0 keeps the call, matching the CocoaPods default.
let bypassLocationAlways = ProcessInfo.processInfo.environment["BYPASS_PERMISSION_LOCATION_ALWAYS"] == "1" ? "1" : "0"

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
                .headerSearchPath("include/geolocator_apple"),
                .define("BYPASS_PERMISSION_LOCATION_ALWAYS", to: bypassLocationAlways)
            ]
        )
    ]
)
