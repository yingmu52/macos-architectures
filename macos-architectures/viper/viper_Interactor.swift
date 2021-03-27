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
            presenter.reloadTable()
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

        case .completed:
            dataSource.remove(at: index)
        }
        presenter.reloadTable()
    }
}
