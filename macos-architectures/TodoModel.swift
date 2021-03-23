//
//  TodoModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Foundation

class TodoModel {
    private var todoItems: [String]
    private var completedItems: [String]
    
    enum Section {
        case todo
        case completed
    }
    
    init() {
        todoItems = UserDefaults.standard.value(forKey: "TodoItems") as? [String] ?? []
        completedItems = UserDefaults.standard.value(forKey: "CompletedItems") as? [String] ?? []
    }
    
    func getSection(with row: Int) -> Section {
        0 ..< todoItems.count ~= row ? .todo : .completed
    }
    
    subscript(index: Int) -> String {
        switch getSection(with: index) {
        case .todo:
            return todoItems[index]
        case .completed:
            return completedItems[index - todoItems.count]
        }
    }
    
    func addTodo(item: String) {
        todoItems.append(item)
        UserDefaults.standard.setValue(todoItems, forKey: "TodoItems")
    }
    
    func removeItem(at index: Int) {
        switch getSection(with: index) {
        case .todo:
            let removedItem = todoItems.remove(at: index)
            completedItems.insert(removedItem, at: 0)
            UserDefaults.standard.setValue(todoItems, forKey: "TodoItems")
        case .completed:
            completedItems.remove(at: index - todoItems.count)
        }
        UserDefaults.standard.setValue(completedItems, forKey: "CompletedItems")
    }
    
    var count: Int {
        todoItems.count + completedItems.count
    }
    
    var status: String {
        "\(todoItems.count) todo \(completedItems.count) completed"
    }
}

