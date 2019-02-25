//
//  OpenQuicklyWindow.swift
//  OpenQuickly
//
//  Created by Luka Kerr on 25/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

class OpenQuicklyWindow: NSWindow {

  override init(
    contentRect: NSRect,
    styleMask style: NSWindow.StyleMask,
    backing backingStoreType: NSWindow.BackingStoreType,
    defer flag: Bool
  ) {
    super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

    self.titleVisibility = .hidden
    self.styleMask = .borderless
    self.backgroundColor = .clear
    self.isOpaque = false
    self.isMovableByWindowBackground = true
  }

  override var canBecomeKey: Bool {
    return true
  }

}
