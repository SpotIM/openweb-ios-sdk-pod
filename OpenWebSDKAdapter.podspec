Pod::Spec.new do |s|
  s.name             = 'OpenWebSDKAdapter'
  s.version          = '2.5.1'
  s.summary          = 'OpenWeb SDK Adapter'
  s.description      = 'OpenWeb Adapter SDK for OpenWebSDK'
  s.homepage        = "https://www.openweb.com"
  s.screenshots     = 'https://github.com/SpotIM/spotim-ios-sdk-pod/assets/8794663/b451b791-92fc-4946-be64-00531d216fd3'
  s.license         = { :type => 'CUSTOM', :file => 'LICENSE' }
  s.author          = { 'Alon Haiut' => 'alon.h@openweb.com' }
  s.platform        = :ios
  s.ios.deployment_target = '12.0'
  s.source          = { :git => 'https://github.com/SpotIM/openweb-ios-sdk-pod.git', :tag => s.version.to_s }

  s.source_files    = "OpenWebSDKAdapter/**/*"
end
