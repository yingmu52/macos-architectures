//
//  viper_Interfaces.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation
import Cocoa

/*
 this is a variant of the standard VIPER concept
 in which V -> I -> P ( -> R, -> V)
 I like this directional way because it avoids using weak reference
 */

protocol viper_ViewInterface: SplitViewControllerSelectionProtocol {
    var interactor: viper_InteractorInterface? { get }
    static func configureVIPER(storyboardName: String) -> Self // return Self for better testability
    func reloadTable()
    func insertNewItem(at index: Int)
    func delteItem(at index: Int)
    func clearTextField()
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
    func insertNewItem(at index: Int)
    func delteItem(at index: Int)
    func reloadTable()
}

protocol viper_EntityInterface: TodoModel {}

protocol viper_RouterInterface {}
