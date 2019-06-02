//
//  OpenQuicklyWindowController.swift
//  OpenQuickly
//
//  Created by Luka Kerr on 25/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

open class OpenQuicklyWindowController: NSWindowController {

  let AUTOSAVE_NAME = "OpenQuicklyWindow"

  var options: OpenQuicklyOptions!

  private var windowIsVisible: Bool {
    return window?.isVisible ?? false
  }

  public convenience init(options: OpenQuicklyOptions) {
    let oqvc = OpenQuicklyViewController(options: options)
    let window = OpenQuicklyWindow(contentViewController: oqvc)

    self.init(window: window)

    self.options = options

    if options.persistPosition {
      window.setFrameAutosaveName(AUTOSAVE_NAME)
    }
  }

  override open func close() {
    if windowIsVisible {
      options.delegate?.windowDidClose()
      super.close()
    }
  }

  public func toggle() {
    if windowIsVisible {
      close()
    } else {
      window?.makeKeyAndOrderFront(self)
      showWindow(self)
    }
  }

}
