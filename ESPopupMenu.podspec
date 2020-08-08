
Pod::Spec.new do |s|
  s.name             = 'ESPopupMenu'
  s.version          = '0.1.1'
  s.summary          = 'An esay-to-use popup menu for iOS.'


  s.description      = <<-DESC
                        It automatically calculates the frames and the arrow position according to the UI Component that pops it.
                       DESC

  s.homepage         = 'https://github.com/ElegantSolution/ESPopupMenu'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ElegantSolution' => 'eesoto@foxmail.com' }
  s.source           = { :git => 'https://github.com/ElegantSolution/ESPopupMenu.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '8.0'

  s.source_files = '*.{h,m}'

end
