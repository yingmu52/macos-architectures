//
//  mvvmrs_ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-23.
//

import Cocoa
import ReactiveSwift

class mvvmrs_ViewController: NSViewController {
    
    @IBOutlet weak private var tableView: NSTableView!
    @IBOutlet weak private var inputTextField: NSTextField!
    
    let viewModel: ViewModelType = mvvmrs_ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTodoView()
        
        tableView.doubleAction = #selector(doubleClick)
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
        
        viewModel.outputs.items.signal.observeValues { [tableView, inputTextField] items in
            tableView?.reloadData()
            inputTextField?.stringValue.removeAll()
        }
        
        viewModel.outputs.status.signal.observeValues { [view] title in
            view.window?.title = title
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.title = viewModel.outputs.status.value
    }
    
    @objc func doubleClick() {
        viewModel.inputs.clicked(at: tableView.clickedRow)
    }
}

extension mvvmrs_ViewController: NSTableViewDelegate, NSTableViewDataSource {
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool { false }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel.outputs.items.value.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        viewModel.outputs.items.value[row].type == .todo ? 40 : 35
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell")
        guard let cell = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView else { return nil }
        let item = viewModel.outputs.items.value[row]
        cell.setup(content: item.content, for: item.type)
        return cell
    }
}

extension mvvmrs_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        viewModel.inputs.addTodo(item: inputTextField.stringValue)
        return true
    }
}
