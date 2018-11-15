# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!
workspace 'ResepFinder'

def networkAndParsingPods
  pod 'Alamofire', '~> 4.7'
end

def firebasePods
  pod 'Firebase'
  pod "Firebase/Database" 
  pod "Firebase/Auth"
end

def generalPods
  pod 'IQKeyboardManagerSwift'
  pod 'TPKeyboardAvoiding', '1.2.9'
  pod 'SVProgressHUD'
  pod 'JVFloatLabeledTextField'
end

target 'ResepFinder' do
  project 'ResepFinder'

  firebasePods
  generalPods
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  #networkAndParsingPods
end


#target 'RFProfileMenu' do
#  project 'RFProfileMenu/RFProfileMenu'
#end

