require 'cocoapods'
require 'json'
require 'xcodeproj'
require 'cocoapods-core'

scheme = Xcodeproj::XCScheme.new('/Users/sunyanguo/Documents/lvioscode/ios_pods_function/LvmmNetwork/Example/Pods/Pods.xcodeproj/xcshareddata/xcschemes/AFNetworking.xcscheme')
puts scheme.methods
# puts Xcodeproj::XCScheme::BuildableReference.new('/Users/sunyanguo/Documents/lvioscode/ios_pods_function/LvmmNetwork/Example/Pods/Pods.xcodeproj/xcshareddata/xcschemes/AFNetworking.xcscheme')