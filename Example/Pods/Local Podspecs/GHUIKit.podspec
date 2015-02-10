#
#  Be sure to run `pod spec lint GHUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GHUIKit"
  s.version      = "0.0.1"
  s.summary      = "UI framework."
  s.homepage     = "https://github.com/gabriel/GHUIKit"
  s.license      = 'MIT'
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/GHUIKit.git", :tag => "0.0.1" }
  s.platform     = :ios, '7.0'
  s.source_files = 'GHUIKit', 'GHUIKit/**/*.{h,m}'
  s.dependency 'GHKit'
  s.dependency 'YapDatabase'
  s.dependency 'SDWebImage'
  s.dependency 'ObjectiveSugar'
  s.frameworks = 'QuartzCore'
  s.requires_arc = true

end
