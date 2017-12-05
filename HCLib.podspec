Pod::Spec.new do |spec|
spec.name             = 'HCLib'
spec.version          = '1.0'
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

spec.dependency 'CocoaAsyncSocket'

end

