#
# Be sure to run `pod lib lint WebAuthentication.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WebAuthentication'
  s.version          = '0.1.2'
  s.summary          = 'Web authentication made easier'

  s.description      = <<-DESC
    Authenticator handles authentication in the corresponding web environmnet depending on the iOS version.                    
  DESC

  s.homepage         = 'https://github.com/InQBarna/WebAuthentication'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'InQBarna' => 'alexis.katsaprakakis@inqbarna.com' }
  s.source           = { :git => 'https://github.com/InQBarna/WebAuthentication.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*.swift' 
    
  # s.resource_bundles = {
  #   'WebAuthentication' => ['WebAuthentication/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
