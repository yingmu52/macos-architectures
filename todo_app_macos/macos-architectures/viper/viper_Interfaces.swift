//
//  viper_Interfaces.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation
import Cocoa

protocol viper_ViewInterface: NSViewController {
    static func configureVIPER(storyboardName: String) -> Self // return Self for better testability
    func reloadTable()
    func insertNewItem(at index: Int)
    func delteItem(at index: Int)
    func clearTextField()
    func updateWindow(title: String)
}

protocol viper_InteractorInterface {
    var presenter: viper_PresenterInterface { get }
    var dataSource: DataSource<viper_Entity> { get }
    func loadData()
    func addTodo(item: String)
    func doubleClick(at index: Int)
}

protocol viper_PresenterInterface {
    var view: viper_ViewInterface { get }
    var router: viper_RouterInterface { get }
    var interactor: viper_InteractorInterface? { get set }

    func bindDataSource(to tableView: NSTableView)
    func loadData()
    func doubleClick(at index: Int)
    
    func insertNewItem(at index: Int)
    func delteItem(at index: Int)
    func reloadTable()
    func setWindowTitle()
    func addTodo(item: String)
}

protocol viper_EntityInterface: TodoModel {}

protocol viper_RouterInterface {}
