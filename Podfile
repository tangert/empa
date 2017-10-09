# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'empa2' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for empa2

  target 'empa2Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'empa2UITests' do
    inherit! :search_paths
    # Pods for testing
  end

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'Alamofire', '~> 4.0'
pod 'AffdexSDK-iOS'
pod 'AWSKinesis'
pod 'Firebase/Core'
pod 'Firebase/Storage'
pod 'Firebase/Auth'

post_install do |installer|
  installer.pods_project.targets.each do |target|
      if (target.name == "AWSCore") || (target.name == 'AWSKinesis')
            puts target.name
            target.build_configurations.each do |config|
                config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
            end
      end
      if (target.name == "Alamofire")
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
end

end
