//
//  viper_Interactor.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation

final class viper_Interactor: viper_InteractorInterface {

    let presenter: viper_PresenterInterface
    let dataSource: DataSource<viper_Entity>
    
    init(presenter: viper_PresenterInterface, dataSource: DataSource<viper_Entity>) {
        self.presenter = presenter
        self.dataSource = dataSource
    }

    func loadData() {
        dataSource.setValues(
            getCachedTodoItems().mapTodoModels() +
                getCachedCompletedItems().mapCompletedModels()
        )
        presenter.reloadTable()
    }
    
    func addTodo(item: String) {
        if !item.isEmpty {
            dataSource.insert(.init(type: .todo, content: item), at: 0)
            presenter.insertNewItem(at: 0)
            saveTodoItems(getCachedTodoItems() + [item])
        }
    }
    
    func doubleClick(at index: Int) {
        let item = dataSource.values[index]
        switch item.type {
        case .todo:
            let removed = dataSource.remove(at: index)
            let todos = dataSource.values.filter { $0.type == .todo }
            let completes = dataSource.values.filter { $0.type == .completed }
            let newComplete = viper_Entity(type: .completed, content: removed.content)
            dataSource.setValues(todos + [newComplete] + completes)
            presenter.delteItem(at: index)
            presenter.insertNewItem(at: todos.count)

            saveTodoItems(todos.map { $0.content })
            saveCompletedItems(([newComplete] + completes).map { $0.content })
        case .completed:
            dataSource.remove(at: index)
            presenter.delteItem(at: index)
            
            let completedItems = dataSource.values
                .filter { $0.type == .completed }
                .map { $0.content }
            saveCompletedItems(completedItems)
        }
    }
}
