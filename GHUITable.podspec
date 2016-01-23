#
#  Be sure to run `pod spec lint GHUIKit.podspec` to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "GHUITable"
  s.version      = "0.1.11"
  s.summary      = "Table UI framework."
  s.homepage     = "https://github.com/gabriel/GHUITable"
  s.license      = "MIT"
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/GHUITable.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.platform     = :ios, "8.0"

  s.default_subspec = "Core"

  s.subspec "Core" do |cs|
    cs.source_files = "GHUITable/**/*.{h,m}"
    cs.dependency "GHKit"
    cs.dependency "ObjectiveSugar"
  end

  s.subspec "Yap" do |sp|
    sp.source_files = "YapTableView/**/*.{h,m}"
    sp.dependency "GHUITable/Core"
    sp.dependency "YapDatabase"
  end

end
