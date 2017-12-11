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
spec.requires_arc = 'Sources/ARC/**/*.{h,m,mm,c}'

spec.prefix_header_file = 'Sources/ARC/GlobalFile/JRPLugin.pch'
spec.preserve_paths = "Sources/**/*.a"
spec.ios.vendored_libraries = "Sources/**/*.a"
spec.resource = "Sources/BundleFiles/**/*.bundle"
#spec.header_dir = ""

spec.libraries = 'iconv','iconv.2.4.0','stdc++','z','sqlite3','c'


#spec.prefix_header_contents = '#import <UIKit/UIKit.h>', '#import <Foundation/Foundation.h>',
#'# import <CoreFoundation/CoreFoundation.h>','# import <CoreGraphics/CoreGraphics.h>',
#'# import <QuartzCore/QuartzCore.h>','# import <AVFoundation/AVFoundation.h>','# import <CoreMedia/CoreMedia.h>',
#'# import <CoreVideo/CoreVideo.h>'

spec.framework    = 'UIKit','MobileCoreServices','CoreGraphics','Foundation','AVFoundation','CoreMedia','CoreVideo','QuartzCore'
#spec.dependency 'CocoaAsyncSocket'
#spec.dependency 'ZBarSDK'
#spec.dependency 'ZBarSDK-hicool', '~> 0.0.1'
#spec.dependency 'objective-zip', '~> 1.0.2'
#spec.dependency 'Minizip', '~> 1.0.0'
#spec.dependency 'HC-Objective-Zip', '~> 2.0'


#spec.xcconfig = { "OTHER_LDFLAGS" => "-ObjC",
#                 "GCC_WARN_UNUSED_FUNCTION" => "NO" }

#spec.xcconfig = { "ENABLE_BITCODE" => "NO"}


spec.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(SRCROOT)/**/**' }

spec.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/**/**' }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT/**}" }

spec.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/**' }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libiconv" }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libiconv.2.4.0" }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libstdc++" }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libz" }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/sqlite3" }

spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/c" }

#spec.xcconfig = { "ALWAYS_SEARCH_USER_PATHS" => "NO" }

spec.xcconfig = { "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES","DEFINES_MODULE" =>"YES" }


spec.subspec 'vendorlibs' do |s|
    s.ios.vendored_libraries = "Sources/**/*.a" #依赖了的.a文件
    #s.ios.vendored_frameworks = "MyCustomLib/YoutuLibs/*.framework"
end


end

