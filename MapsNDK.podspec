Pod::Spec.new do |s|
  s.name          = 'MapsNDK'
  s.version       = '1.0.0'
  s.summary       = 'MapsNDK for iOS'
  s.homepage      = 'https://github.com/mapsndk/distribution'
  s.author        = { 'MapsNDK' => 'no-reply@example.com' }
  s.license       = { :type => 'Commercial'}
  s.source        = { :http => 'https://github.com/mapsndk/distribution/releases/download/1.0.0/MapsNDK.zip',
                      :flatten => false }
  s.swift_version = '5.10'
  s.platform     = :ios, '15.0'

  s.frameworks = 'Metal', 'MetalKit', 'Accelerate'
  s.libraries = 'c++'

  s.vendored_frameworks = 'core.xcframework',
                          'CoreBridge.xcframework',
                          'CoreSwiftBridge.xcframework',
                          'MapsNDKEngine.xcframework',
                          'MapsNDKBridge.xcframework',
                          'MapsNDK.xcframework',
                          'Escort.xcframework',
                          'RouteEngineCore.xcframework',
                          'RouteEngineBridge.xcframework'
end
