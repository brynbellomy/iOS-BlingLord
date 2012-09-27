Pod::Spec.new do |s|
  s.name         = "iOS-BlingLord"
  s.version      = "0.0.1"
  s.author       = { "bryn austin bellomy" => "bryn.bellomy@gmail.com" }
  s.summary      = "iOS springboard (home screen) style view controller"
  s.homepage     = "http://brynbellomy.github.com/iOS-BlingLord"
  s.license      = "WTFPL"

  s.source       = { :git => "https://github.com/brynbellomy/iOS-BlingLord.git", :commit => "10cccaa4a1be5b8828406a9e7cc32db1338af3e1" }
  s.source_files = "iOS-BlingLord/*.{h,m}"

  s.platform     = :ios, ">= 4.3"
  s.requires_arc = true

  s.dependency "BrynKit", ">= 0.0.1"
end
