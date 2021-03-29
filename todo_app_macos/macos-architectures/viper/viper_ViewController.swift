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
    
    var presenter: viper_PresenterInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTheme()
        tableView.doubleAction = #selector(doubleClick)
        inputTextField.delegate = self
        inputTextField.placeholderString = "Add new todo here"
        
        presenter?.bindDataSource(to: tableView)
        presenter?.loadData()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setWindowTitle()
    }
    
    @objc func doubleClick() {
        presenter?.doubleClick(at: tableView.clickedRow)
    }
}

extension viper_ViewController: viper_ViewInterface {

    func insertNewItem(at index: Int) {
        tableView.insertRows(at: [index], withAnimation: .slideDown)
    }
    
    func delteItem(at index: Int) {
        tableView.removeRows(at: [index], withAnimation: .slideRight)
    }
    
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
        var presenter = viper_Presenter(view: vc, router: router)
        
        let dataSource = DataSource<viper_Entity>([])
        let interactor = viper_Interactor(presenter: presenter, dataSource: dataSource)
        presenter.interactor = interactor
        
        vc.presenter = presenter
        return vc
    }
    
    func updateWindow(title: String) {
        view.window?.title = title
    }
}

extension viper_ViewController: SplitViewControllerSelectionProtocol {
    func setWindowTitle() {
        presenter?.setWindowTitle()
    }
}

extension viper_ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        presenter?.addTodo(item: inputTextField.stringValue)
        return true
    }
}
