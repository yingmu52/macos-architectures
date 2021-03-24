//
//  TodoModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-22.
//

import Foundation

enum TodoType {
    case todo
    case completed
}


class mvc_Model {
    private var todoItems: [String]
    private var completedItems: [String]

    init() {
        todoItems = UserDefaults.standard.value(forKey: "TodoItems") as? [String] ?? []
        completedItems = UserDefaults.standard.value(forKey: "CompletedItems") as? [String] ?? []
    }
    
    func section(of index: Int) -> TodoType {
        0 ..< todoItems.count ~= index ? .todo : .completed
    }
    
    subscript(index: Int) -> String {
        switch section(of: index) {
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
        switch section(of: index) {
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

