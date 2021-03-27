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
        inputTextField.delegate = self
        
        interactor?.dataSource.bind(to: tableView)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        interactor?.loadData()
    }
}

extension viper_ViewController: viper_ViewInterface {

    func reloadTable() {
        tableView.reloadData()
    }
    
    static func configureVIPER(storyboardName: String) -> viper_ViewController {
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialController() as! viper_ViewController

        let router = viper_Router()
        let presenter = viper_Presenter(view: vc, router: router)

        let dataSource: DataSource<viper_Entity> = DataSource<viper_Entity>.createFromCache()
        let interactor = viper_Interactor(presenter: presenter, dataSource: dataSource)

        vc.interactor = interactor

        return vc
    }
}

extension viper_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        view.window?.title = "[VIPER] \(interactor?.dataSource.numberOfRows(in: tableView))"
    }
}

extension viper_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
//        viewModel.inputs.addTodo(item: inputTextField.stringValue)
        return true
    }
}
