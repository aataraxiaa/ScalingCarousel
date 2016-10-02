#
# Be sure to run `pod lib lint ScalingCarouselView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScalingCarousel'
  s.version          = '1.0'
  s.summary          = 'A super simple carousel view with scaling cells written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ScalingCarouselView is a super simple carousel view with scaling cells written in Swift.
                       DESC

  s.homepage         = 'https://github.com/superpeteblaze/ScalingCarousel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pete Smith' => 'peadar81@gmail.com' }
  s.source           = { :git => 'https://github.com/superpeteblaze/ScalingCarousel.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/superpeteblaze'

  s.platform = :ios
  s.ios.deployment_target = '9.0'

  s.source_files = 'ScalingCarousel/Classes/**/*'
  s.frameworks = 'UIKit'
end
