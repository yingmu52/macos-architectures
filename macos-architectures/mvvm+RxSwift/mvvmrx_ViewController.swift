//
//  mvvmrx_ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Cocoa
import RxSwift
import RxCocoa

class mvvmrx_ViewController: NSViewController {
    
    @IBOutlet weak private var tableView: NSTableView!
    @IBOutlet weak private var inputTextField: NSTextField!
    
    let bag = DisposeBag()
    let viewModel: mvvmrx_ViewModelType = mvvmrx_ViewModel()
    let dataSource = DataSource<mvvmrx_Model>([])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setupTheme()
        dataSource.bind(to: tableView)
        
        inputTextField.delegate = self
        tableView.doubleAction = #selector(doubleClick)
        
        viewModel.outputs.items
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let strongSelf = self else { return }
                strongSelf.dataSource.setValues(items)
                strongSelf.tableView.reloadData()
                strongSelf.inputTextField.stringValue.removeAll()
            })
            .disposed(by: bag)
        
        viewModel.outputs.status
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [view] status in
                view.window?.title = status
            })
            .disposed(by: bag)
    }
    
    @objc func doubleClick() {
        viewModel.inputs.clicked(at: tableView.clickedRow)
    }
}

extension mvvmrx_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        viewModel.inputs.queryStatus()
    }
}

extension mvvmrx_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        viewModel.inputs.addTodo(item: inputTextField.stringValue)
        return true
    }
}
