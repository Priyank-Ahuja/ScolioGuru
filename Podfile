# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ScolioGuru' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ScolioGuru
  pod 'YouTubePlayer'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
