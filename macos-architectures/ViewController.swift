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
    
    var todoItems = [String]() {
        didSet {
            self.view.window?.title = "\(todoItems.count) todo items"
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use signal column
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.sizeLastColumnToFit()
        
        // remove header view
        tableView.headerView = nil
        
        // remove table view selection color
        tableView.selectionHighlightStyle = .regular
        
        // add space between cell
        tableView.intercellSpacing = NSSize(width: 5, height: 5)
        
        tableView.doubleAction = #selector(doubleClick)
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
    }
    
    @objc func doubleClick() {
        todoItems.remove(at: tableView.clickedRow)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell"), owner: nil)
                as? NSTableCellView else { return nil }
        // set cell style
        cell.wantsLayer = true
        cell.layer?.backgroundColor = NSColor.systemIndigo.cgColor
        cell.layer?.cornerRadius = 5
        
        cell.textField?.stringValue = todoItems[row]
        cell.textField?.textColor = .white
        return cell
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // Do something against ENTER key
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        if !inputTextField.stringValue.isEmpty {
            todoItems.append(inputTextField.stringValue)
            inputTextField.stringValue.removeAll()
        }
        return true
    }
}
