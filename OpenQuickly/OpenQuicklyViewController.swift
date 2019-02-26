//
//  OpenQuicklyViewController.swift
//  OpenQuickly
//
//  Created by Luka Kerr on 25/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

class OpenQuicklyViewController: NSViewController, NSTextFieldDelegate {

  let ESC_KEYCODE: UInt16 = 53
  let DOWN_ARROW_KEYCODE: UInt16 = 125
  let UP_ARROW_KEYCODE: UInt16 = 126
  let ENTER_KEYCODE: UInt16 = 36

  /// The data used to display the matches
  private var matches: [Any]!

  /// Configuration options
  private var options: OpenQuicklyOptions!

  /// Various views
  private var clipView: NSClipView!
  private var stackView: NSStackView!
  private var scrollView: NSScrollView!
  private var searchField: NSTextField!
  private var matchesList: NSOutlineView!
  private var transparentView: NSVisualEffectView!

  /// The Open Quickly window controller instance for this view
  private var openQuicklyWindowController: OpenQuicklyWindowController? {
    return view.window?.windowController as? OpenQuicklyWindowController
  }

  init(options: OpenQuicklyOptions) {
    super.init(nibName: nil, bundle: nil)

    self.options = options
    self.matches = []
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let frame = NSRect(
      x: 0,
      y: 0,
      width: options.width,
      height: options.height
    )

    view = NSView()
    view.frame = frame
    view.wantsLayer = true
    view.layer?.cornerRadius = options.radius + 1
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupSearchField()
    setupTransparentView()
    setupMatchesListView()
    setupScrollView()
    setupStackView()

    stackView.addArrangedSubview(searchField)
    stackView.addArrangedSubview(scrollView)
    transparentView.addSubview(stackView)
    view.addSubview(transparentView)

    setupConstraints()

    matchesList.doubleAction = #selector(itemSelected)
  }

  override func viewWillAppear() {
    searchField.stringValue = ""

    if !options.persistMatches {
      clearMatches()
    }

    view.window?.makeFirstResponder(searchField)
  }

  override var acceptsFirstResponder: Bool {
    return true
  }

  override func keyUp(with event: NSEvent) {
    let keyCode = event.keyCode

    if keyCode == ESC_KEYCODE {
      openQuicklyWindowController?.toggle()
      return
    }

    if keyCode == ENTER_KEYCODE {
      itemSelected()
      return
    }

    if [DOWN_ARROW_KEYCODE, UP_ARROW_KEYCODE].contains(keyCode) {
      return
    }

    let value = searchField.stringValue

    matches = options.delegate?.valueWasEntered(value)

    reloadMatches()
  }

  @objc func itemSelected() {
    let selected = matchesList.item(atRow: matchesList.selectedRow) as Any

    if let delegate = options.delegate {
      delegate.itemWasSelected(selected: selected)
    }

    openQuicklyWindowController?.toggle()
  }

  // MARK: - UI management

  private func clearMatches() {
    matches = []
    reloadMatches()
  }

  private func reloadMatches() {
    matchesList.reloadData()
    updateViewSize()
  }

  private func updateViewSize() {
    let numMatches = matches.count > options.matchesShown
      ? options.matchesShown : matches.count

    let rowHeight = CGFloat(numMatches) * options.rowHeight
    let newHeight = options.height + rowHeight

    let newSize = NSSize(width: options.width, height: newHeight)

    guard var frame = view.window?.frame else { return }

    frame.origin.y += frame.size.height;
    frame.origin.y -= newSize.height;
    frame.size = newSize

    view.setFrameSize(newSize)
    transparentView.setFrameSize(newSize)
    view.window?.setFrame(frame, display: true)
    stackView.spacing = matches.count > 0 ? 5.0 : 0.0
  }

  // MARK: - UI setup

  private func setupSearchField() {
    searchField = NSTextField()
    searchField.delegate = self
    searchField.alignment = .left
    searchField.isEditable = true
    searchField.isBezeled = false
    searchField.isSelectable = true
    searchField.font = options.font
    searchField.focusRingType = .none
    searchField.drawsBackground = false
    searchField.placeholderString = options.placeholder
  }

  private func setupTransparentView() {
    let frame = NSRect(
      x: 0,
      y: 0,
      width: options.width,
      height: options.height
    )

    transparentView = NSVisualEffectView()
    transparentView.frame = frame
    transparentView.state = .active
    transparentView.wantsLayer = true
    transparentView.blendingMode = .behindWindow
    transparentView.layer?.cornerRadius = options.radius
    transparentView.material = options.material
  }

  private func setupMatchesListView() {
    matchesList = NSOutlineView()
    matchesList.delegate = self
    matchesList.headerView = nil
    matchesList.wantsLayer = true
    matchesList.dataSource = self
    matchesList.selectionHighlightStyle = .sourceList

    let column = NSTableColumn()
    matchesList.addTableColumn(column)
  }

  private func setupScrollView() {
    scrollView = NSScrollView()
    scrollView.borderType = .noBorder
    scrollView.drawsBackground = false
    scrollView.autohidesScrollers = true
    scrollView.hasVerticalScroller = true
    scrollView.documentView = matchesList
    scrollView.translatesAutoresizingMaskIntoConstraints = true
  }

  private func setupStackView() {
    stackView = NSStackView()
    stackView.spacing = 0.0
    stackView.orientation = .vertical
    stackView.distribution = .fillEqually
    stackView.edgeInsets = options.edgeInsets
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }

  private func setupConstraints() {
    let stackViewConstraints = [
      stackView.topAnchor.constraint(equalTo: transparentView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor)
    ]

    NSLayoutConstraint.activate(stackViewConstraints)
  }

}

extension OpenQuicklyViewController: NSOutlineViewDataSource {

  /// Number of items in the matches list
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return matches.count
  }

  /// Items to be added to the matches list
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return matches[index]
  }

  /// Whether items in the matches list are expandable by an arrow
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  /// Height of each item in the matches list
  func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    return options.rowHeight
  }

  /// When an item in the matches list is clicked on should it be selected
  func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    return true
  }

}

extension OpenQuicklyViewController: NSOutlineViewDelegate {

  /// The view for each item in the matches array
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    return options.delegate?.openQuickly(item: item)
  }

}
