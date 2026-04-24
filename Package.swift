// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapsNDK",
    platforms: [
          .iOS(.v15),
          .macOS(.v12)
    ],
    products: [
        .library(
            name: "MapsNDK",
            targets: [
                "core", "CoreBridge", "CoreSwiftBridge",
                "MapsNDKEngine", "MapsNDKBridge", "MapsNDK",
                "Escort", "RouteEngineCore", "RouteEngineBridge"
            ]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "core",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/core.xcframework.zip",
            checksum: "bfd97baede6de27ba788d88b511c8d144948d72225d33452af56d004d954dfd2"
        ),
        .binaryTarget(
            name: "CoreBridge",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/CoreBridge.xcframework.zip",
            checksum: "b6a2b5532df2dd852a31e5adbf165bf119f5559ecb61294088650fcefc7a1f23"
        ),
        .binaryTarget(
            name: "CoreSwiftBridge",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/CoreSwiftBridge.xcframework.zip",
            checksum: "3432896e761c4fe5d51d81704d2478a5dadf00c619158479761f3df858c1ffe8"
        ),
        .binaryTarget(
            name: "MapsNDKBridge",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/MapsNDKBridge.xcframework.zip",
            checksum: "8122f2ab159638c9a7852828cc85d2d781f45401df8fe8b1599a7bf5b7ced874"
        ),
        .binaryTarget(
            name: "MapsNDK",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/MapsNDK.xcframework.zip",
            checksum: "221fddfc2341aed0ed0b5be9bb2971f7c6115cb768d938055f6bab41efbc3650"
        ),
        .binaryTarget(
            name: "MapsNDKEngine",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/MapsNDKEngine.xcframework.zip",
            checksum: "3d9ca9d65b3ac315836540bb75987c46d14177d9f315a15edc682b4b746669c0"
        ),
        .binaryTarget(
            name: "Escort",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/Escort.xcframework.zip",
            checksum: "17c1c6c071d05ada832537d361429254e84c66e0549452437eb11693efec718e"
        ),
        .binaryTarget(
            name: "RouteEngineCore",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/RouteEngineCore.xcframework.zip",
            checksum: "dc9cde2d1e44cfd33dbabd089928649325c63e8c681164a41184036d5a4d13f7"
        ),
        .binaryTarget(
            name: "RouteEngineBridge",
            url: "https://github.com/mapsndk/distribution/releases/download/1.0.0/RouteEngineBridge.xcframework.zip",
            checksum: "aa2622c31b132007ac3bfce28663913ccddff23bb4a7002d9d54a85315907f73"
        )
    ]
)
