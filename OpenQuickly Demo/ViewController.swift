//
//  ViewController.swift
//  OpenQuickly Demo
//
//  Created by Luka Kerr on 25/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa
import OpenQuickly

struct Language {
  var name: String
  var subtitle: String
  var image: NSImage
}

let languages: [Language] = [
  Language(
    name: "Swift",
    subtitle: "A general-purpose, multi-paradigm, compiled programming language",
    image: NSWorkspace.shared.icon(forFileType: ".swift")
  ),
  Language(
    name: "JavaScript",
    subtitle: "A high-level, interpreted programming language",
    image: NSWorkspace.shared.icon(forFileType: ".js")
  ),
  Language(
    name: "Java",
    subtitle: "A general-purpose computer-programming language",
    image: NSWorkspace.shared.icon(forFileType: ".java")
  ),
  Language(
    name: "Python",
    subtitle: "An interpreted, high-level, general-purpose programming language",
    image: NSWorkspace.shared.icon(forFileType: ".py")
  ),
  Language(
    name: "Ruby",
    subtitle: "A dynamic, interpreted, reflective, object-oriented, general-purpose programming language",
    image: NSWorkspace.shared.icon(forFileType: ".rb")
  ),
  Language(
    name: "Go",
    subtitle: "A statically typed, compiled programming language",
    image: NSWorkspace.shared.icon(forFileType: ".go")
  ),
  Language(
    name: "Markdown",
    subtitle: "A lightweight markup language",
    image: NSWorkspace.shared.icon(forFileType: ".md")
  ),
  Language(
    name: "Bash",
    subtitle: "A Unix shell and command language",
    image: NSWorkspace.shared.icon(forFileType: ".sh")
  )
]

class ViewController: NSViewController {

  private var openQuicklyWindowController: OpenQuicklyWindowController!

  override func viewDidLoad() {
    super.viewDidLoad()

    let openQuicklyOptions = OpenQuicklyOptions()
    openQuicklyOptions.width = 500
    openQuicklyOptions.rowHeight = 50
    openQuicklyOptions.delegate = self
    openQuicklyOptions.persistPosition = true
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
    guard let language = item as? Language else { return nil }

    let view = NSStackView()

    let imageView = NSImageView(image: language.image)

    let title = NSTextField()

    title.isEditable = false
    title.isBezeled = false
    title.isSelectable = false
    title.focusRingType = .none
    title.drawsBackground = false
    title.font = NSFont.systemFont(ofSize: 14)
    title.stringValue = language.name

    let subtitle = NSTextField()

    subtitle.isEditable = false
    subtitle.isBezeled = false
    subtitle.isSelectable = false
    subtitle.focusRingType = .none
    subtitle.drawsBackground = false
    subtitle.stringValue = language.subtitle
    subtitle.font = NSFont.systemFont(ofSize: 12)

    let text = NSStackView()
    text.orientation = .vertical
    text.spacing = 2.0
    text.alignment = .left

    text.addArrangedSubview(title)
    text.addArrangedSubview(subtitle)

    view.addArrangedSubview(imageView)
    view.addArrangedSubview(text)

    return view
  }

  func valueWasEntered(_ value: String) -> [Any] {
    let matches = languages.filter {
      $0.name.lowercased().contains(value.lowercased())
    }

    return matches
  }

  func itemWasSelected(selected item: Any) {
    guard let language = item as? Language else { return }

    print("\(language.name) was selected")
  }

  func windowDidClose() {
    print("Window did close")
  }

}

