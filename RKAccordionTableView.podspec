#
# Be sure to run `pod lib lint RKAccordionTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RKAccordionTableView'
  s.version          = '1.0.0'
  s.summary          = 'An Advanced accordion for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
RKAccordionTableView is an advanced accordion built upon `UITableView`. Users can decide the action to be done on a section to expand/collapse. It can be a button at the side, or a tap action on the section, its upto you. You can enable/disable reordering for each row or section. Reorder is done by tap and drag action on an accordion row/section. Additionally there is an option to toggle Footer views in each section. Footers cannot be reordered.
                       DESC

  s.homepage         = 'https://github.com/Radhakrishna Pai/RKAccordionTableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Radhakrishna Pai' => 'radhakrishnapai09@gmail.com' }
  s.source           = { :git => 'https://github.com/Radhakrishna Pai/RKAccordionTableView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RKAccordionTableView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RKAccordionTableView' => ['RKAccordionTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
