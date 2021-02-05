#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint geolocator.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'geolocator'
  s.version          = '6.2.0'
  s.summary          = 'Geolocation plugin for Flutter.'
  s.description      = <<-DESC
  Geolocation plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API for generic location (GPS etc.) functions.
                       DESC
  s.homepage         = 'http://github.com/baseflow/flutter-geolocator'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
