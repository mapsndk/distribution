# MapsNDK

Cross-platform maps for iOS and Android.

- iOS 15+ (Metal)
- Android API 24+ (Vulkan / OpenGL ES)

## Installation

### iOS — Swift Package Manager

Add to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mapsndk/distribution.git", from: "1.0.0")
]
```

Then link the `MapsNDK` product:

```swift
.product(name: "MapsNDK", package: "distribution")
```

Or add via Xcode: **File → Add Package Dependencies** → `https://github.com/mapsndk/distribution` → pick `MapsNDK`.

### iOS — CocoaPods (local / offline)

Not published to the CocoaPods trunk (trunk goes read-only 2026-12-02). Install from a local, vendored copy.

1. Download the bundle + podspec into your project:

    ```bash
    mkdir -p vendor/MapsNDK && cd vendor/MapsNDK
    curl -LO https://github.com/mapsndk/distribution/releases/download/1.0.0/MapsNDK.zip
    curl -LO https://raw.githubusercontent.com/mapsndk/distribution/1.0.0/MapsNDK.podspec
    unzip -q MapsNDK.zip && rm MapsNDK.zip
    ```

    Resulting `vendor/MapsNDK/`:

    ```
    MapsNDK.podspec
    core.xcframework/
    CoreBridge.xcframework/
    CoreSwiftBridge.xcframework/
    MapsNDKEngine.xcframework/
    MapsNDKBridge.xcframework/
    MapsNDK.xcframework/
    Escort.xcframework/
    RouteEngineCore.xcframework/
    RouteEngineBridge.xcframework/
    MapsNDK.doccarchive/
    ```

2. Reference the folder from your `Podfile` (`:path =>` skips network — uses files in place):

    ```ruby
    pod 'MapsNDK', :path => 'vendor/MapsNDK'
    ```

3. Install:

    ```bash
    pod install
    ```

Upgrade later = replace the `vendor/MapsNDK/` contents with a newer release's zip+podspec and re-run `pod install`.

### Android — Gradle (GitHub Packages)

GitHub Packages requires authentication even for public reads. Create a PAT with `read:packages` scope.

In `~/.gradle/gradle.properties`:

```properties
gpr.user=<your-github-username>
gpr.key=<PAT-with-read:packages>
```

In your project's `settings.gradle`:

```groovy
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/mapsndk/distribution")
            credentials {
                username = settings.ext.find("gpr.user") ?: System.getenv("GITHUB_ACTOR")
                password = settings.ext.find("gpr.key")  ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }
}
```

In your module `build.gradle`:

```groovy
dependencies {
    implementation "com.maps.ndk:maps-ndk:1.0.0"
}
```