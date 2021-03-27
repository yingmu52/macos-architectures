//
//  viper_ViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Cocoa

final class viper_ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var inputTextField: NSTextField!
    
    var interactor: viper_InteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTheme()
        tableView.doubleAction = #selector(doubleClick)
        inputTextField.delegate = self
        inputTextField.placeholderString = "Add new todo here"
        
        interactor?.dataSource.bind(to: tableView)
        interactor?.loadData()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setWindowTitle()
    }
    
    @objc func doubleClick() {
        interactor?.doubleClick(at: tableView.clickedRow)
    }
}

extension viper_ViewController: viper_ViewInterface {
    func reloadTable() {
        tableView.reloadData()
    }
    
    func clearTextField() {
        inputTextField.stringValue = String()
    }
    
    static func configureVIPER(storyboardName: String) -> viper_ViewController {
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialController() as! viper_ViewController

        let router = viper_Router()
        let presenter = viper_Presenter(view: vc, router: router)

        let dataSource = DataSource<viper_Entity>([])
        let interactor = viper_Interactor(presenter: presenter, dataSource: dataSource)
        
        vc.interactor = interactor

        return vc
    }
}

extension viper_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        guard let interactor = self.interactor else { return }
        view.window?.title = "[VIPER] \(interactor.dataSource.status)"
    }
}

extension viper_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        interactor?.addTodo(item: inputTextField.stringValue)
        return true
    }
}
