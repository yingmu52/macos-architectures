//
//  mvvmrs_ViewModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-23.
//

import ReactiveSwift
import Cocoa

protocol ViewModelInputs {
    func addTodo(item: String)
    func clicked(at index: Int)
}

protocol ViewModelOutputs {
    var items: Property<[Model]> { get }
    var status: Property<String> { get }
}

protocol mvvmrs_ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}


final class mvvmrs_ViewModel: mvvmrs_ViewModelType, ViewModelInputs, ViewModelOutputs {
    var inputs: ViewModelInputs { self }
    var outputs: ViewModelOutputs { self }
    
    private let _todoItems = MutableProperty(UserDefaults.standard.value(forKey: "TodoItems") as? [String] ?? [])
    private let _completedItems = MutableProperty(UserDefaults.standard.value(forKey: "CompletedItems") as? [String] ?? [])

    private let _clickedIndex = MutableProperty<Int?>(nil)

    let items: Property<[Model]>
    let status: Property<String>
    
    init() {
        let combineItems  = SignalProducer
            .combineLatest(_todoItems.producer.map(mapTodoModels), _completedItems.producer.map(mapCompleteModels))
            .map { $0.0 + $0.1 }
        items = Property(initial: [], then: combineItems)
        
        status = Property
            .combineLatest(_todoItems, _completedItems)
            .map { "\($0.count) todo \($1.count) completed" }
        
        _todoItems.signal.observeValues { items in
            UserDefaults.standard.setValue(items, forKey: "TodoItems")
        }
        
        _completedItems.signal.observeValues { items in
            UserDefaults.standard.setValue(items, forKey: "CompletedItems")
        }
    }
}

// MARK: - Inputs

extension mvvmrs_ViewModel {
    func addTodo(item: String) {
        guard !item.isEmpty else { return }
        _todoItems.value.append(item)
    }
    
    func clicked(at index: Int) {
        switch index {
        case 0 ..< _todoItems.value.count:
            let removed = _todoItems.value.remove(at: index)
            _completedItems.value.insert(removed, at: 0)
        case _todoItems.value.count ..< _todoItems.value.count + _completedItems.value.count:
            _completedItems.value.remove(at: index - _todoItems.value.count)
        default:
            break
        }
    }
}
