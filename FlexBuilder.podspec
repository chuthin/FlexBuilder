Pod::Spec.new do |s|
  s.name             = 'FlexBuilder'
  s.version          = ENV['LIB_VERSION'] || '1.0.0'
  s.summary          = 'SwiftUI builder patterns for UIKit '
  s.description      = 'A Declarative UIKit Library'
  s.homepage         = "https://github.com/chuthin/FlexBuilder"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chu thin' => 'thincv@live.com' }
  s.source           = { :git => 'https://github.com/chuthin/FlexBuilder.git', :tag => s.version.to_s }
  s.swift_version = '5.5'
  s.ios.deployment_target = '11.0'
  s.source_files = 'Sources/FlexBuilder/**/*'
  s.dependency 'FlexLayout', '~> 1.3'
  s.dependency 'PinLayout', '1.10.0'
  s.dependency 'RxSwift', '~> 6.5.0'
  s.dependency 'RxCocoa', '~> 6.5.0'
end