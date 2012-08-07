Pod::Spec.new do |s|
  s.name         = "iOS-BlingLord"
  s.version      = "0.0.1"
  s.source       = { :git => "/Users/bryn/repo/iOS-BlingLord.git" }
  s.platform     = :ios, '4.3'
  s.source_files = 'iOS-BlingLord/*.{h,m}'

  s.requires_arc = true

  s.xcconfig = { 'PUBLIC_HEADERS_FOLDER_PATH' => 'include/$(TARGET_NAME)' }

  s.dependency 'BrynKit', '>= 0.0.1'
  # s.dependency 'KJGridLayout', '??'

end
