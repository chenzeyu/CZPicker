Pod::Spec.new do |s|
  s.name = 'CZPicker'
  s.version = '1.0.0'
  s.summary = 'Beautiful selection sheets for SwiftUI and UIKit. Zero dependencies.'
  s.homepage = 'https://github.com/chenzeyu/CZPicker'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'chenzeyu' => 'zeyufly@gmail.com' }
  s.source = { :git => 'https://github.com/chenzeyu/CZPicker.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.requires_arc = true
  s.swift_versions = ['5.0']
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Pod/Classes/*.{h,m}'
    core.public_header_files = 'Pod/Classes/*.h'
    core.frameworks = 'UIKit'
  end

  s.subspec 'SwiftUI' do |modern|
    modern.ios.deployment_target = '16.0'
    modern.source_files = 'Sources/CZPickerUI/*.swift'
    modern.frameworks = 'SwiftUI', 'UIKit'
  end
end
