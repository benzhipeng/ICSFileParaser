
Pod::Spec.new do |s|
  s.name             = "WeCalICS"
  s.version          = "1.0.0"
  s.summary          = "A marquee view used on iOS."
  s.description      = <<-DESC
                       It is a marquee view used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "http://git.etouch.cn/gitbucket/WeCal/WeCalICS"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "B.E.N" => "benzhipeng1990@gmail.com" }
  s.source           = { :git => "http://git.etouch.cn/gitbucket/git/WeCal/WeCalICS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/NAME'


  s.platform     = :ios, '6.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.subspec 'WeCalendar' do |ss|
  ss.source_files = 'WeCalICS/WeCalICS/Sources/WCCalendar/*.{h,m}'
  end

  s.subspec 'LibIcal' do |ss|
  ss.source_files = 'WeCalICS/WeCalICS/Sources/libical/src/include/*.{h}'
  ss.ios.vendored_library = 'WeCalICS/WeCalICS/Sources/libical/lib/libical.a'
  ss.resources = 'WeCalICS/WeCalICS/Sources/libical/zoneinfo'
  end

  s.subspec 'Sources' do |ss|
  ss.source_files = 'WeCalICS/WeCalICS/Sources/*.{h,m}'
  end

  # s.ios.exclude_files = 'Classes/osx'
  # s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'
end
