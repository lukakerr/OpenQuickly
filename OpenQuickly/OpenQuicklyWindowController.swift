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

  public convenience init(options: OpenQuicklyOptions) {
    let oqvc = OpenQuicklyViewController(options: options)
    let window = OpenQuicklyWindow(contentViewController: oqvc)

    self.init(window: window)

    if options.persistPosition {
      window.setFrameAutosaveName(AUTOSAVE_NAME)
    }
  }

  public func toggle() {
    guard let visible = window?.isVisible else { return }

    if visible {
      close()
    } else {
      window?.makeKeyAndOrderFront(self)
      showWindow(self)
    }
  }

}
