#
# Be sure to run `pod lib lint DryAWSS3-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 提交仓库:
# pod spec lint DryAWSS3-iOS.podspec --allow-warnings --use-libraries
# pod trunk push DryAWSS3-iOS.podspec --allow-warnings --use-libraries
#

Pod::Spec.new do |s|
  
  # Git
  s.name        = 'DryAWSS3-iOS'
  s.version     = '0.0.2'
  s.summary     = 'DryAWSS3-iOS'
  s.homepage    = 'https://github.com/duanruiying/DryAWSS3-iOS'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author      = { 'duanruiying' => '2237840768@qq.com' }
  s.source      = { :git => 'https://github.com/duanruiying/DryAWSS3-iOS.git', :tag => s.version.to_s }
  s.description = <<-DESC
  TODO: 亚马逊AWSS3简化集成(文件上传).
  DESC
  
  # User
  #s.swift_version         = '5.0'
  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.user_target_xcconfig  = {'OTHER_LDFLAGS' => ['-w', '-ObjC']}
  
  # Pod
  #s.static_framework      = true
  s.pod_target_xcconfig   = {'OTHER_LDFLAGS' => ['-w']}
  
  # Code
  s.source_files          = 'DryAWSS3-iOS/Classes/Code/**/*'
  s.public_header_files   = 'DryAWSS3-iOS/Classes/Code/Public/**/*.h'
  
  # System
  #s.libraries  = 'z', 'sqlite3.0', 'c++'
  s.frameworks = 'UIKit', 'Foundation'
  
  # ThirdParty
  #s.vendored_libraries  = ''
  #s.vendored_frameworks = ''
  s.dependency 'AWSS3'
  
end
