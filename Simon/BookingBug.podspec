#
# Be sure to run `pod lib lint BookingBug.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                      = "BookingBug"
  s.version                   = "0.1.0"
  s.summary                   = "A short description of BookingBug."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description               = <<-DESC
                                DESC

  s.homepage                  = "https://bookingbug.com"
  s.license                   = 'MIT'
  s.author                    = { "BookingBug" => "dev@bookingbug.com" }
  s.source                    = { :git => "https://github.com/bookingbug/LibBookingBug-Swift.git", :tag => s.version.to_s }
  s.social_media_url          = 'https://twitter.com/bookingbug'

  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.9'
  # s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc              = true

  s.default_subspecs          = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files           = 'Pod/Classes/Core/**/*'

    ss.dependency 'Result', '~> 1.0'
    ss.dependency 'Unbox', '~> 1.3'
    ss.dependency 'URITemplate', '~> 1.3'
  end

  s.subspec 'RxSwift' do |ss|
    ss.source_files           = 'Pod/Classes/RxSwift/**/*'

    ss.dependency 'BookingBug/Core'
    ss.dependency 'RxSwift', '~> 2.1'
  end
end
