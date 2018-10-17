# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'MyIns' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyIns
  pod 'Firebase/Core'
  pod 'AlamofireImage', '~> 3.2'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'
  pod 'IQKeyboardManagerSwift'

  target 'MyInsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyInsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end


source 'https://github.com/CocoaPods/Specs.git'		
use_frameworks!

pod "PagingMenuController"

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
