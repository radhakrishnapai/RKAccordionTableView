Pod::Spec.new do |s|
  s.name             = "RKAccordionTableView"
  s.version          = "1.0.1"
  s.summary          = 'An Advanced accordion for iOS.'
  s.description      = 'RKAccordionTableView is an advanced accordion built upon UITableView.'
  s.homepage         = 'https://github.com/radhakrishnapai/RKAccordionTableView'
  # s.screenshots    = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Radhakrishna Pai' => 'radhakrishnapai09@gmail.com' }
  s.source           = { :git => 'https://github.com/radhakrishnapai/RKAccordionTableView.git', :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.source_files     = 'RKAccordionTableView/Classes/**/*'
end
