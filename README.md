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

## Quick start — display a map

Each snippet below is the minimum needed to render a map. Swap `YOUR_API_KEY` and `https://maps.example.com` for your own credentials, and supply your style JSON.

### iOS — SwiftUI

```swift
import SwiftUI
import MapsNDK

@main
struct MyApp: App {
    init() {
        MapsNDKConfigurator.setup(
            baseURL: "https://maps.example.com",
            apiKey: "YOUR_API_KEY"
        )
    }
    var body: some Scene { WindowGroup { MapScreen() } }
}

struct MapScreen: View {
    @StateObject private var state = MapViewHolder()
    var body: some View {
        MapRepresentable(view: state.mapView)
            .ignoresSafeArea()
    }
}

final class MapViewHolder: ObservableObject {
    let mapView: MapView

    init() {
        let url = Bundle.main.url(forResource: "style", withExtension: "json")!
        let styleJSON = try! String(contentsOf: url, encoding: .utf8)
        mapView = MapView(configuration: MapConfiguration(
            center: Coordinates(lng: 0.0, lat: 0.0),
            zoom: 12,
            pitch: Angle(degrees: 0),
            maxPitch: Angle(degrees: 60),
            bearing: Angle(degrees: 0),
            customStyle: styleJSON,
            fonts: []
        ))
    }
}

struct MapRepresentable: UIViewRepresentable {
    let view: MapView
    func makeUIView(context: Context) -> MapView { view }
    func updateUIView(_ uiView: MapView, context: Context) {}
}
```

`MapView` is a `UIView`/`NSView` — wrap with `UIViewRepresentable`/`NSViewRepresentable` for SwiftUI or add it directly to a UIKit/AppKit hierarchy.

### Android — Compose (minimal)

The shortest path: create `MapView` and call `applyConfig()` once. The view is rebuilt if its host `Activity` is recreated (e.g. on rotation).

**`AndroidManifest.xml`**
```xml
<uses-permission android:name="android.permission.INTERNET" />

<application android:name=".App" ...>
    <activity android:name=".MainActivity" android:exported="true">
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>
    </activity>
</application>
```

**`App.kt`**
```kotlin
class App : Application() {
    override fun onCreate() {
        super.onCreate()
        MapsNDK.setup(
            baseUrl = "https://maps.example.com",
            apiKey = "YOUR_API_KEY",
            context = this,
        )
    }
}
```

**`MainActivity.kt`**
```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { MapScreen() }
    }
}

@Composable
fun MapScreen() {
    val context = LocalContext.current
    val styleJson = remember {
        context.assets.open("style.json").bufferedReader().use { it.readText() }
    }
    val config = remember {
        MapViewConfig(
            center = LatLon(latitude = 0.0, longitude = 0.0),
            zoomLevel = 12.0,
            pitchDegrees = 0.0,
            maxPitchDegrees = 60.0,
            bearingDegrees = 0.0,
            style = Style.Type.Json(json = styleJson),
            fonts = arrayOf(),
        )
    }
    AndroidView(
        modifier = Modifier.fillMaxSize(),
        factory = { ctx -> MapView(ctx).apply { applyConfig(config) } },
        onRelease = { it.destroy() },
    )
}
```

`applyConfig()` is a one-shot initializer — subsequent calls on the same `MapView` are ignored.

### Android — Compose (production: `MapState` in `Application`)

Hold `MapState` in the `Application` so the map survives configuration changes (rotation, theme switch) without being torn down and rebuilt from scratch:

**`App.kt`**
```kotlin
class App : Application() {
    var mapState: MapState? = null

    override fun onCreate() {
        super.onCreate()
        MapsNDK.setup(
            baseUrl = "https://maps.example.com",
            apiKey = "YOUR_API_KEY",
            context = this,
        )
        val styleJson = assets.open("style.json").bufferedReader().use { it.readText() }
        mapState = MapState(MapViewConfig(
            center = LatLon(latitude = 0.0, longitude = 0.0),
            zoomLevel = 12.0,
            pitchDegrees = 0.0,
            maxPitchDegrees = 60.0,
            bearingDegrees = 0.0,
            style = Style.Type.Json(json = styleJson),
            fonts = arrayOf(),
        ))
    }
}
```

**`MapScreen.kt`**
```kotlin
@Composable
fun MapScreen() {
    val app = LocalContext.current.applicationContext as App
    AndroidView(
        modifier = Modifier.fillMaxSize(),
        factory = { ctx ->
            MapView(ctx).apply {
                val state = requireNotNull(app.mapState)
                setMapState(state)
                state.mapViewConfig?.let { applyConfig(it) }
            }
        },
        onRelease = { it.destroy() },
    )
}
```