Pod::Spec.new do |s|
  s.name         = "SHXMLParser"
  s.version      = "1.0.0"
  s.summary      = "Easy to use automatic XML Parser built on NSXMLParser."
  s.homepage     = "https://github.com/simhanature/SHXMLParser"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Narasimharaj C" => "simhanature@gmail.com" }
  s.source       = { :git => "https://github.com/simhanature/SHXMLParser.git", :tag => "v1.0.0", :commit => "157cf47c5edc56500731612a8ff452643702c958" }
  s.platform     = :ios, '5.0'
  s.source_files = 'SHXMLParser/*.{h,m}'
  s.requires_arc = true
end
