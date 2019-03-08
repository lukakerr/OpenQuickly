Pod::Spec.new do |s|
  s.name             = 'OpenQuickly'
  s.version          = '0.0.1'
  s.summary          = 'A custom macOS window that imitates macOS\' Spotlight, written in Swift.'

  s.homepage         = 'https://github.com/lukakerr/OpenQuickly'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Luka Kerr'
  s.source           = { :git => 'https://github.com/lukakerr/OpenQuickly.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.12'
  s.swift_version = '4.2'

  s.source_files = 'OpenQuickly/**/*'
  s.public_header_files = 'OpenQuickly/*.h'
  s.exclude_files = "OpenQuickly/Info.plist"
end
