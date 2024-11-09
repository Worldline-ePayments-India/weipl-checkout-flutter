#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint weipl_checkout_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'weipl_checkout_flutter'
  s.version          = '1.1.0'
  s.summary          = 'Flutter plugin for Worldline ePayments India SDK.'
  s.description      = 'This is official Flutter plugin for Worldline ePayments India SDK.'
  s.homepage         = 'https://github.com/Worldline-ePayments-India/weipl-checkout-flutter'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Ashish Palaskar' => 'ashish.palaskar@worldline.com' }
  s.source           = { :git => 'https://github.com/Worldline-ePayments-India/weipl-checkout-flutter.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*.{h,m,swift}'
  s.dependency 'Flutter'
  s.dependency 'weipl_checkout'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
