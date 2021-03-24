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
        tableView.setupTodoView()
        
        tableView.doubleAction = #selector(doubleClick)
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setWindowTitle()
    }
}

extension ViewController {
    @objc func doubleClick() {
        removeItem(at: tableView.clickedRow)
    }
    
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
        let id = NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell")
        guard let cell = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView else { return nil }
        cell.setup(content: model[row], for: model.section(of: row))
        return cell
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        addTodo(item: inputTextField.stringValue)
        return true
    }
}
