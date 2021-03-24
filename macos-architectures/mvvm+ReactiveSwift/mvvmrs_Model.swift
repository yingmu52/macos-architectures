//
//  mvvmrs_Model.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Foundation

struct Model {
    var type: TodoType
    let content: String
}

func mapTodoModels(_ items: [String]) -> [Model] {
    items.map { Model(type: .todo, content: $0) }
}

func mapCompleteModels(_ items: [String]) -> [Model] {
    items.map { Model(type: .completed, content: $0) }
}
