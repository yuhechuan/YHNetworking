Pod::Spec.new do |s|

  s.name         = "YHCNetworking"
  s.version      = "1.0.1"
  s.summary      = "A tool to realize broken-point downloading! Support: http://www.jianshu.com/u/7c43d8cb3cff"
  s.homepage     = "https://github.com/yuhechuan/YHNetworking"
  s.license      = "MIT"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/yuhechuan/YHNetworking.git", :tag => s.version }
  s.source_files = "Sources/**/*.{h,m}"
  s.requires_arc = true

  s.author       = { "yuhechuan" => "yuhechuan@ruaho.com" }

end