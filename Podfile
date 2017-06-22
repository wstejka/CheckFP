# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'CheckFuelPrice' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CheckFuelPrice

  # Pull in FirebaseUI Auth features
  # Leave this version set to 2.7
  # reason: https://stackoverflow.com/questions/44188112/undefined-symbols-for-architecture-x86-64-in-xcode-after-firebase-update?answertab=active#tab-top
  pod 'TwitterKit' , '2.7'
  pod 'FirebaseUI', '~> 4.0'

  pod 'Firebase/Performance'
  # Due to information from Firebase team Crashlytics will become soon the first crash reporter
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'HockeySDK', '~> 4.1.5'

end

plugin 'cocoapods-keys', {
  :project => "CheckFP",
  :keys => [
    "HockeyAppIdentifier",
    "TwitterConsumerKey",
    "TwitterConsumerSecret"
  ]}
