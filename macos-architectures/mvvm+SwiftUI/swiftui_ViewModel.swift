//
//  swiftui_ViewModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import SwiftUI

protocol swiftui_ViewModelType {
    var inputs: swiftui_ViewModelInputs { get }
    var outputs: swiftui_ViewModelOutputs { get }
}
protocol swiftui_ViewModelInputs {
    func removeTodo(item: swiftui_Model)
    func removeCompleted(item: swiftui_Model)
    func addTodo(item: String)
}

protocol swiftui_ViewModelOutputs {
    var todoItems: [swiftui_Model] { get }
    var completedItems: [swiftui_Model] { get }
    var draftingNewItem: String { get set }
    var status: String { get }
}

class swiftui_ViewModel: ObservableObject, swiftui_ViewModelType, swiftui_ViewModelOutputs {

    var inputs: swiftui_ViewModelInputs { self }
    var outputs: swiftui_ViewModelOutputs { self }

    @Published var todoItems: [swiftui_Model] = []
    @Published var completedItems: [swiftui_Model] = []
    @Published var draftingNewItem = String()
    var status: String {
        "[MVVM + SwiftUI] \(todoItems.count) todos \(completedItems.count) completed"
    }
}

extension swiftui_ViewModel: swiftui_ViewModelInputs {
    func removeTodo(item: swiftui_Model) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            let removed = todoItems.remove(at: index)
            let newCompleted = swiftui_Model(type: .completed, content: removed.content)
            completedItems.insert(newCompleted, at: 0)
            saveTodoModels(todoItems)
            saveCompletedModels(completedItems)
        }
    }
    
    func removeCompleted(item: swiftui_Model) {
        if let index = completedItems.firstIndex(where: { $0.id == item.id }) {
            completedItems.remove(at: index)
            saveCompletedModels(completedItems)
            return
        }
    }
    
    func addTodo(item: String) {
        if !item.isEmpty {
            todoItems.insert(.init(type: .todo, content: item), at: 0)
            draftingNewItem.removeAll()
        }
    }
}
