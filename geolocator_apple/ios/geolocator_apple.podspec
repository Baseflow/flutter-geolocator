#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint geolocator.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'geolocator_apple'
  s.version          = '1.2.0'
  s.summary          = 'Geolocation iOS plugin for Flutter.'
  s.description      = <<-DESC
  Geolocation iOS plugin for Flutter. This plugin provides the Apple implementation for the geolocator plugin.
                       DESC
  s.homepage         = 'http://github.com/baseflow/flutter-geolocator'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :http => 'https://github.com/baseflow/flutter-geolocator/tree/master/' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.module_map = 'Classes/GeolocatorPlugin.modulemap'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
