#
# Be sure to run `pod lib lint PGNotificationView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PGNotificationView'
  s.version          = '1.0.0'
  s.summary          = 'Simple NotificationView Creator'
  s.description      = 'you can create NotificationView(inApp) simply and you setup the NotificationView(inApp) easily.'
  s.homepage         = 'https://github.com/ipagong/PGNotificationView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ipagong.dev' => 'ipagong.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/ipagong/PGNotificationView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'PGNotificationView/Classes/**/*'
  
end
