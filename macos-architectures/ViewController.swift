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
    
    internal lazy var model: TodoModel = {
        TodoModel()
    }()
    
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setWindowTitle()
    }
    
    @objc func doubleClick() {
        removeItem(at: tableView.clickedRow)
    }
}

extension ViewController {
    func setWindowTitle() {
        view.window?.title = model.status
    }
    
    func addTodo(item: String) {
        guard !item.isEmpty else { return }
        model.addTodo(item: inputTextField.stringValue)
        tableView.reloadData()
        setWindowTitle()
        inputTextField.stringValue.removeAll()
    }
    
    func removeItem(at index: Int) {
        model.removeItem(at: index)
        tableView.reloadData()
        setWindowTitle()
    }
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool { false }
    
    func numberOfRows(in tableView: NSTableView) -> Int { model.count }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        model.section(of: row) == .todo ? 40 : 35
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell"), owner: nil)
                as? NSTableCellView else { return nil }
        // set cell style
        cell.wantsLayer = true
        cell.layer?.cornerRadius = 5
        cell.textField?.textColor = .white
        
        switch model.section(of: row) {
        case .todo:
            cell.layer?.backgroundColor = NSColor.systemIndigo.cgColor
            cell.textField?.attributedStringValue = NSAttributedString(string: model[row], attributes: [
                .foregroundColor: NSColor.white,
            ])
        case .completed:
            cell.layer?.backgroundColor = NSColor.lightGray.cgColor
            cell.textField?.attributedStringValue = NSAttributedString(string: model[row], attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: NSColor.black,
                .foregroundColor: NSColor.white,
            ])
        }
        return cell
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // Do something against ENTER key
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        addTodo(item: inputTextField.stringValue)
        return true
    }
}
