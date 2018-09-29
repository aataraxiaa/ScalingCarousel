#
# Be sure to run `pod lib lint ScalingCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScalingCarousel'
  s.version          = '2.4'
  s.summary          = 'A super simple carousel view with scaling transitions written in Swift'

  s.description      = <<-DESC
ScalingCarousel provides a simple carousel-style collection view.
It takes care of cell presentation, scaling each cell as the collection view is scrolled.

It is used in Bikey to present bike station information.
                       DESC

  s.homepage         = 'https://github.com/superpeteblaze/ScalingCarousel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pete Smith' => 'peadar81@gmail.com' }
  s.source           = { :git => 'https://github.com/superpeteblaze/ScalingCarousel.git', :tag => "v#{s.version.to_s}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ScalingCarousel/Classes/**/*'
end
