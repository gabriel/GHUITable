#
#  Be sure to run `pod spec lint GHUIKit.podspec` to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GHUITable"
  s.version      = "0.1.5"
  s.summary      = "UI framework."
  s.homepage     = "https://github.com/gabriel/GHUITable"
  s.license      = "MIT"
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/GHUITable.git", :tag => s.version.to_s }
  s.platform     = :ios, "7.0"
  s.source_files = "GHUITable/**/*.{h,m}"
  s.dependency "GHKit"
  s.dependency "ObjectiveSugar"
  s.requires_arc = true

  s.subspec "Yap" do |a|
    a.source_files = "GHUITable/**/*.{h,m}", "YapTableView/**/*.{h,m}"
    a.dependency "YapDatabase"
  end

end
