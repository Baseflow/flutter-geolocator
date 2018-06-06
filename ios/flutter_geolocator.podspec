#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_geolocator'
  s.version          = '0.0.1'
  s.summary          = 'Geolocation plugin for Flutter (based on the excellent Geolocator plugin for Xamarin by James Montemagno)'
  s.description      = <<-DESC
Geolocation plugin for Flutter (based on the excellent Geolocator plugin for Xamarin by James Montemagno)
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'
end

