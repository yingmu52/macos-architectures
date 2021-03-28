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
    
    let viewModel: mvvmrs_ViewModelType = mvvmrs_ViewModel()
    let dataSource = DataSource([mvvmrs_Model]())

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTheme()
        
        tableView.doubleAction = #selector(doubleClick)
        dataSource.bind(to: tableView)
        inputTextField.delegate = self
        inputTextField.placeholderString = "Add new todo here"

        viewModel.outputs.items.producer.startWithValues { [tableView, inputTextField, dataSource] items in
            dataSource.setValues(items)
            tableView?.reloadData()
            inputTextField?.stringValue.removeAll()
        }
        
        viewModel.outputs.status.startWithValues { [view] title in
            view.window?.title = title
        }
    }
    
    @objc func doubleClick() {
        viewModel.inputs.clicked(at: tableView.clickedRow)
    }
}

extension mvvmrs_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        viewModel.inputs.queryStatus()
    }
}

extension mvvmrs_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        viewModel.inputs.addTodo(item: inputTextField.stringValue)
        return true
    }
}
