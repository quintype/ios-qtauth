#
# Be sure to run `pod lib lint QTAuth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QTAuth'
  s.version          = '0.2.2'
  s.summary          = 'Authentication (Login) library developed by Quintype'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/quintype/ios-qtauth'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Quintype' => 'ios@quintype.com' }
  s.source           = { :git => 'https://github.com/quintype/ios-qtauth.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '4.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'QTAuth/Classes/**/*'
  
   s.resource_bundles = {
     'QTAuth' => ['QTAuth/Assets/*']
   }
   
   s.static_framework = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'FacebookLogin', '~> 0.9.0'
  s.dependency 'GoogleSignIn', '~> 5.0.1'
  s.dependency 'TwitterKit', '3.4.2'
  s.dependency 'LinkedinSwift', '~> 1.7.7'
end
