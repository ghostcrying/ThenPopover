Pod::Spec.new do |s|
  s.name         = "ThenPopover"
  s.version      = "0.0.2"
  s.license      = "LICENSE"
  s.summary      = "Similar with system alert controller, with custom animation."
  s.description  = <<-EOS
  Instructions for installation are in [the README](https://github.com/ghostcrying/ThenPopover).
  EOS
  s.homepage     = "https://github.com/ghostcrying/ThenPopover"
  s.author       = { "ghost" => "czios1501@gmail.com" }
  s.source       = { :git => "https://github.com/ghostcrying/ThenPopover.git", :tag => s.version }
  
  s.ios.deployment_target = '11.0'
  s.source_files = "Sources/**/*.swift"
  s.frameworks = 'Foundation', 'UIKit'
  s.swift_version = '5.0'
  
end

