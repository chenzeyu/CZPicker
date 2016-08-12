#
# Be sure to run `pod lib lint CZPicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CZPicker"
  s.version          = "0.4.3"
  s.summary          = "CZPicker is a picker view shown as a popup."
  s.description      = <<-DESC
                        CZPicker is flexible. It is shown as a popup with customizations.

                       DESC
  s.homepage         = "https://github.com/chenzeyu/CZPicker"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "chenzeyu" => "zeyufly@gmail.com" }
  s.source           = { :git => "https://github.com/chenzeyu/CZPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/chenzeyu'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*'
  s.public_header_files = 'Pod/Classes/*.h'
  s.frameworks = 'UIKit'
end
