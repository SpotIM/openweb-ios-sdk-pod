Pod::Spec.new do |s|
  s.name             = 'OpenWebSDK'
  s.version          = '2.9.0'
  s.summary          = 'OpenWeb SDK'
  s.description      = 'This SDK allows you to integrate OpenWeb into your iOS app.'
  s.homepage        = "https://www.openweb.com"
  s.screenshots     = 'https://github.com/SpotIM/spotim-ios-sdk-pod/assets/8794663/b451b791-92fc-4946-be64-00531d216fd3'
  s.license         = { :type => 'CUSTOM', :file => 'LICENSE' }
  s.author          = { 'OpenWeb' => 'ios-dev@openweb.com' }
  s.platform        = :ios
  s.ios.deployment_target = '13.0'

# the Pre-Compiled Framework:
  s.source          = { :git => 'https://github.com/SpotIM/openweb-ios-sdk-pod.git', :tag => s.version.to_s }
  s.ios.vendored_frameworks = 'OpenWebSDK.xcframework'
  s.dependency 'RxSwift', '~> 6.9.0'
  s.dependency 'RxRelay', '~> 6.9.0'
  s.dependency 'RxCocoa', '~> 6.9.0'
  s.dependency 'OpenWebCommon', '~> 1.0.0'
end
