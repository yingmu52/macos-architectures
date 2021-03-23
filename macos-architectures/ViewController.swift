//
//  ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak private var tableView: NSTableView!
    @IBOutlet weak private var inputTextField: NSTextField!
    
    private(set) var todoItems = [String]() {
        didSet {
            setWindowTitle()
            tableView.reloadData()
            UserDefaults.standard.set(todoItems, forKey: "TodoItems")
        }
    }
    
    private(set) var completedItems = [String]() {
        didSet {
            setWindowTitle()
            tableView.reloadData()
        }
    }
    
    func setWindowTitle() {
        view.window?.title = "\(todoItems.count) todo items \(completedItems.count) completed"
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
        
        readData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setWindowTitle()
    }
    
    func readData() {
        if let items = UserDefaults.standard.value(forKey: "TodoItems") as? [String] {
            todoItems = items
        }
    }
    
    @objc func doubleClick() {
        let removedItem = todoItems.remove(at: tableView.clickedRow)
        completedItems.append(removedItem)
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
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
        cell.textField?.textColor = .white
        
        cell.textField?.stringValue = todoItems[row]
        return cell
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // Do something against ENTER key
        guard commandSelector == #selector(NSResponder.insertNewline), !inputTextField.stringValue.isEmpty else { return false }
        
        todoItems.append(inputTextField.stringValue)
        inputTextField.stringValue.removeAll()
        return true
    }
}
