
//  Array.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Foundation
import Cocoa

protocol TodoModel {
    var type: TodoType { get }
    var content: String { get }
    init(type: TodoType, content: String)
}

enum TodoType {
    case todo
    case completed
}

extension String {
    func mapTodoModel<T: TodoModel>() -> T {
        T(type: .todo, content: self)
    }
    
    func mapCompletedModel<T: TodoModel>() -> T {
        T(type: .completed, content: self)
    }
}

extension Array where Element == String {
    
    func mapTodoModels<T>() -> [T] where T: TodoModel {
        map { $0.mapTodoModel() }
    }
    
    func mapCompletedModels<T>() -> [T] where T: TodoModel {
        map { $0.mapCompletedModel() }
    }
}


func mapTodoModels<T: TodoModel>(_ items: [String]) -> [T] {
    items.map {
        T(type: .todo, content: $0)
    }
}

func mapCompletedModels<T: TodoModel>(_ items: [String]) -> [T] {
    items.map { T(type: .completed, content: $0) }
}

func getCachedTodoItems() -> [String] {
    UserDefaults.standard.value(forKey: "TodoItems") as? [String] ?? []
}

func getCachedCompletedItems() -> [String] {
    UserDefaults.standard.value(forKey: "CompletedItems") as? [String] ?? []
}
