platform :ios, '10.0'
use_frameworks!

target 'Redpoll' do
end

target 'MessagesExtension' do
    pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'Swift-3.0'
    pod 'XLForm'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name === 'XLForm'
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'XL_APP_EXTENSIONS']
            end
        end
    end
end
