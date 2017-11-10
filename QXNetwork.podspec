Pod::Spec.new do |s|

s.name         = "QXNetwork"
s.version      = "1.0.0"
s.summary      = "A very easy use, high customizable http request tool based on URLSession."
s.description  = <<-DESC
A very easy use, high customizable http request tool based on URLSession. With leveled error handler, various of call back handlers and thread safe features.
DESC
s.homepage     = "https://github.com/labi3285/QXNetwork"
s.license      = "MIT"
s.author       = { "labi3285" => "766043285@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/labi3285/QXNetwork.git", :tag => "#{s.version}" }
s.source_files  = "QXNetwork/QXConsMaker/*.swift"
s.requires_arc = true

end
