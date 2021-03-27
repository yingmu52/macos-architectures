//
//  swiftui_ViewModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import SwiftUI

protocol swiftui_ViewModelInputs {
    var removingTodoItem: swiftui_Model? { get set }
    var removingCompletedItem: swiftui_Model? { get set }
    var newItem: String { get set }
}

protocol swiftui_ViewModelOutputs {
    var todoItems: [swiftui_Model] { get set }
    var completedItems: [swiftui_Model] { get set }
}

class swiftui_ViewModel: ObservableObject, swiftui_ViewModelInputs, swiftui_ViewModelOutputs {

    @Published var todoItems: [swiftui_Model] = []
    @Published var completedItems: [swiftui_Model] = []
    @Published var newItem = String()
    
    @Published var removingTodoItem: swiftui_Model? {
        didSet {
            if let index = todoItems.firstIndex(where: { $0.id == removingTodoItem?.id }) {
                let removed = todoItems.remove(at: index)
                let newCompleted = swiftui_Model(type: .completed, content: removed.content)
                completedItems.insert(newCompleted, at: 0)
                saveTodoModels(todoItems)
                saveCompletedModels(completedItems)
            }
        }
    }
    
    @Published var removingCompletedItem: swiftui_Model? {
        didSet {
            if let index = completedItems.firstIndex(where: { $0.id == removingCompletedItem?.id }) {
                completedItems.remove(at: index)
                saveCompletedModels(completedItems)
                return
            }
        }
    }
}
