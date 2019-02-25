//
//  ViewController.swift
//  OpenQuickly Demo
//
//  Created by Luka Kerr on 25/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa
import OpenQuickly

let languages = [
  "Rust",
  "JavaScript",
  "C++",
  "Swift",
  "Java",
  "C#",
  "Python",
  "TypeScript",
  "Ruby",
  "Go",
  "Haskell",
  "Scala",
  "Objective C",
  "Elm",
  "OCaml"
]

class ViewController: NSViewController {

  private var openQuicklyWindowController: OpenQuicklyWindowController!

  override func viewDidLoad() {
    super.viewDidLoad()

    let openQuicklyOptions = OpenQuicklyOptions()
    openQuicklyOptions.width = 500
    openQuicklyOptions.delegate = self
    openQuicklyOptions.placeholder = "Search for a language"

    self.openQuicklyWindowController = OpenQuicklyWindowController(options: openQuicklyOptions)

    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
      if self.keyDown(with: event) {
        return nil
      }

      return event
    }
  }

  func keyDown(with event: NSEvent) -> Bool {
    let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

    // Shift + Command + O
    if modifierFlags == [.command, .shift] && event.keyCode == 31 {
      openQuicklyWindowController.toggle()
      return true
    }

    return false
  }

}

extension ViewController: OpenQuicklyDelegate {

  func openQuickly(item: Any) -> NSView? {
    guard let title = item as? String else { return nil }

    let view = NSTextField()

    view.isEditable = false
    view.isBezeled = false
    view.isSelectable = false
    view.focusRingType = .none
    view.drawsBackground = false
    view.stringValue = title

    return view
  }

  func valueWasEntered(_ value: String) -> [Any] {
    let matches = languages.filter {
      $0.lowercased().contains(value.lowercased())
    }

    return matches
  }

  func itemWasSelected(selected item: Any) {
    guard let language = item as? String else { return }

    print("\(language) was selected")
  }

}

