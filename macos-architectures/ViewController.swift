//
//  ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Cocoa

enum TableSection {
    case todo
    case completed
}

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
            UserDefaults.standard.set(todoItems, forKey: "CompletedItems")
        }
    }
    
    func setWindowTitle() {
        view.window?.title = "\(todoItems.count) Todos \(completedItems.count) completed"
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
        if let items = UserDefaults.standard.value(forKey: "CompletedItems") as? [String] {
            completedItems = items
        }
    }
    
    @objc func doubleClick() {
        removeItem(tableView.clickedRow)
    }
}

extension ViewController {
    func getSection(_ row: Int) -> TableSection {
        return 0 ..< todoItems.count ~= row ? .todo : .completed
    }
    
    func getItem(_ row: Int) -> String {
        switch getSection(row) {
        case .todo:
            return todoItems[row]
        case .completed:
            return completedItems[row - todoItems.count]
        }
    }
    
    func removeItem(_ row: Int) {
        switch getSection(row) {
        case .todo:
            let removedItem = todoItems.remove(at: row)
            completedItems.insert(removedItem, at: 0)
        case .completed:
            completedItems.remove(at: row - todoItems.count)
        }
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return todoItems.count + completedItems.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        switch getSection(row) {
        case .todo: return 40
        case .completed: return 35
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell"), owner: nil)
                as? NSTableCellView else { return nil }
        // set cell style
        cell.wantsLayer = true
        cell.layer?.cornerRadius = 5
        cell.textField?.textColor = .white
        
        switch getSection(row) {
        case .todo:
            cell.layer?.backgroundColor = NSColor.systemIndigo.cgColor
        case .completed:
            cell.layer?.backgroundColor = NSColor.lightGray.cgColor
        }
        
        cell.textField?.stringValue = getItem(row)
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
