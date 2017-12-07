Pod::Spec.new do |spec|
spec.name             = 'HCLib'
spec.version          = '1.1'
spec.summary          = 'Guide for private pods :'
spec.description      = <<-DESC
Guide for private pods
DESC
spec.homepage         = 'https://github.com/hexiaochong/HCLib'
spec.license          = { :type => 'MIT', :file => 'LICENSE' }
spec.author           = { 'hexiaochong' => '980929274@qq.com' }
spec.source           = { :git => 'https://github.com/hexiaochong/HCLib.git'}
spec.platform     = :ios, "8.0"

spec.source_files = 'Sources/**/*.{h,m,mm,c}'

spec.requires_arc = false
spec.requires_arc = 'Sources/ARC/**/*.{m,mm,c}'

spec.prefix_header_file = 'Sources/ARC/GlobalFile/JRPLugin.pch'


spec.preserve_paths = "Sources/Lib/*.a"
spec.vendored_libraries = "Sources/Lib/*.a"
spec.resource = "BundleFiles/*.bundle"
spec.libraries = 'iconv.2.4.0','stdc++','z','sqlite3'

spec.framework    = 'MobileCoreServices'
spec.dependency 'CocoaAsyncSocket'
spec.dependency 'ZBarSDK'
#spec.dependency 'objective-zip', '~> 1.0.2'
#spec.dependency 'Minizip', '~> 1.0.0'


#spec.dependency 'HC-Objective-Zip', '~> 2.0'

spec.xcconfig = { "OTHER_LDFLAGS" => "-ObjC",
                 "GCC_WARN_UNUSED_FUNCTION" => "NO" }
spec.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)' }
spec.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(SRCROOT)"' }   
  
spec.xcconfig  = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)"' }

spec.xcconfig  = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}" }

end

