//
//  viper_Presenter.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation
import Cocoa

// use struct to avoid reference cycle

struct viper_Presenter: viper_PresenterInterface {
    var view: viper_ViewInterface
    var router: viper_RouterInterface
    var interactor: viper_InteractorInterface?
    
    init(view: viper_ViewInterface, router: viper_RouterInterface) {
        self.view = view
        self.router = router
    }
    
    func reloadTable() {
        view.reloadTable()
        view.clearTextField()
        setWindowTitle()
    }
    
    func insertNewItem(at index: Int) {
        view.insertNewItem(at: index)
        view.clearTextField()
        setWindowTitle()
    }
    
    func delteItem(at index: Int) {
        view.delteItem(at: index)
        view.clearTextField()
        setWindowTitle()
    }
    
    func bindDataSource(to tableView: NSTableView) {
        interactor?.dataSource.bind(to: tableView)
    }
    
    func loadData() {
        interactor?.loadData()
    }
    
    func doubleClick(at index: Int) {
        interactor?.doubleClick(at: index)
    }
    
    func setWindowTitle() {
        guard let interactor = interactor else { return }
        let title = "[VIPER] \(interactor.dataSource.status)"
        view.updateWindow(title: title)
    }
    
    func addTodo(item: String) {
        interactor?.addTodo(item: item)
    }
}
