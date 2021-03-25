//
//  ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Cocoa

class mvc_ViewController: NSViewController {
    
    @IBOutlet weak private var tableView: NSTableView!
    @IBOutlet weak private var inputTextField: NSTextField!
    
    let dataSource = DataSource([mvc_Model]())
    
    private var _todoItems = [String]() {
        didSet {
            dataSource.setValues(_todoItems.mapTodoModels() + _completedItems.mapCompletedModels())
            UserDefaults.standard.setValue(_todoItems, forKey: "TodoItems")
        }
    }
    
    private var _completedItems = [String]() {
        didSet {
            dataSource.setValues(_todoItems.mapTodoModels() + _completedItems.mapCompletedModels())
            UserDefaults.standard.setValue(_completedItems, forKey: "CompletedItems")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTheme()
        
        tableView.doubleAction = #selector(doubleClick)
        dataSource.bind(to: tableView)
        inputTextField.delegate = self
        
        _todoItems = getCachedTodoItems()
        _completedItems = getCachedCompletedItems()
        tableView.reloadData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setWindowTitle()
    }
}

extension mvc_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        view.window?.title = "[MVC] \(dataSource.status)"
    }
}

extension mvc_ViewController {
    @objc func doubleClick() {
        let index = tableView.clickedRow
        switch index {
        case 0 ..< _todoItems.count:
            let removed = _todoItems.remove(at: index)
            _completedItems.insert(removed, at: 0)
            tableView.beginUpdates()
            tableView.removeRows(at: [index], withAnimation: .slideDown)
            tableView.insertRows(at: [_todoItems.count], withAnimation: .slideDown)
            tableView.endUpdates()
        case _todoItems.count ..< _todoItems.count + _completedItems.count:
            _completedItems.remove(at: index - _todoItems.count)
            tableView.removeRows(at: [index], withAnimation: .slideRight)
        default:
            break
        }
    }
    
    func addTodo(item: String) {
        guard !item.isEmpty else { return }
        _todoItems.insert(item, at: 0)
        tableView.reloadData()
        setWindowTitle()
        inputTextField.stringValue.removeAll()
    }
    
    func removeItem(at index: Int) {
        dataSource.remove(at: index)
        tableView.reloadData()
        setWindowTitle()
    }
}

extension mvc_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        addTodo(item: inputTextField.stringValue)
        return true
    }
}
