//
//  ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var inputTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.sizeLastColumnToFit()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.headerView = nil
        tableView.selectionHighlightStyle = .regular
        tableView.intercellSpacing = NSSize(width: 5, height: 5)
    }
    
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 100
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell"), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = "https://stackoverflow.com/questions/64913812/set-cell-corner-radius-in-nstableview"
            cell.textField?.textColor = .white
            cell.adjustBackground(.systemIndigo)
            cell.layer?.cornerRadius = 5
            return cell
        }
        return nil
    }
}

extension NSView {
    func adjustBackground(_ color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}

