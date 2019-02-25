# OpenQuickly

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://github.com/apple/swift)
[![Platform](http://img.shields.io/badge/platform-macOS-red.svg?style=flat)](https://developer.apple.com/macos/)
[![Github](http://img.shields.io/badge/github-lukakerr-green.svg?style=flat)](https://github.com/lukakerr)

A custom macOS window that imitates macOS' Spotlight, written in Swift.

### Installation

#### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :osx, '10.12'

target 'MyApp' do
  pod 'OpenQuickly', :git => 'https://github.com/lukakerr/OpenQuickly.git'
end
```

### Usage

A demo can be found at [OpenQuickly Demo](./OpenQuickly Demo).

Most of the functionality is provided already, but some options can be implemented to control the look and feel of the OpenQuickly dialog.

Options include:

- Font used
- Radius of window
- Width and height of window
- Max number of matches shown
- Height of each matches row
- Placeholder text
- Whether to persist the window position
- Padding (i.e. edge insets)
- Material (i.e. theme/window appearance)

If there are any options you think are missing, please raise an issue.

### Screenshots

<p align="center">
  <img src="https://i.imgur.com/PLCRasq.png" width="400">
  <img src="https://i.imgur.com/SPOwsbN.png" width="400">
  <br>
  <img src="https://i.imgur.com/w4lh0YW.png">
</p>