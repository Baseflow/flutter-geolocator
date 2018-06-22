#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'geolocator'
  s.version          = '0.0.1'
  s.summary          = 'Geolocation plugin for Flutter'
  s.description      = <<-DESC
Geolocation plugin for Flutter
                       DESC
  s.homepage         = 'http://github.com/BaseflowIT/flutter-geolocator'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'
end

