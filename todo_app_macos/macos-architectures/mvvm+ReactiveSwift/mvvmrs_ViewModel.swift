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
    func queryStatus()
}

protocol ViewModelOutputs {
    var items: SignalProducer<[mvvmrs_Model], Never> { get }
    var status: SignalProducer<String, Never> { get }
}

protocol mvvmrs_ViewModelType {
    var inputs: ViewModelInputs { get }
    var outputs: ViewModelOutputs { get }
}


final class mvvmrs_ViewModel: mvvmrs_ViewModelType, ViewModelInputs, ViewModelOutputs {
    var inputs: ViewModelInputs { self }
    var outputs: ViewModelOutputs { self }
    
    private let _todoItems = MutableProperty(getCachedTodoItems())
    private let _completedItems = MutableProperty(getCachedCompletedItems())

    private let _clickedIndex = MutableProperty<Int?>(nil)
    private let _queryStatus = MutableProperty<Void?>(nil)
    let items: SignalProducer<[mvvmrs_Model], Never>
    let status: SignalProducer<String, Never>
    
    init() {
        items = SignalProducer
            .combineLatest(_todoItems.producer, _completedItems.producer)
            .map { (todoItems, completedItems) in
                todoItems.mapTodoModels() + completedItems.mapCompletedModels()
            }

        status = SignalProducer
            .combineLatest(_todoItems.producer, _completedItems.producer, _queryStatus.producer.skipNil())
            .map { (todoItems, completedItems, _) in
                "[MVVM + ReactiveSwift] \(todoItems.count) todo \(completedItems.count) completed"
            }
        
        _todoItems.signal.observeValues { items in
            saveTodoItems(items)
        }
        
        _completedItems.signal.observeValues { items in
            saveCompletedItems(items)
        }
    }
}

// MARK: - Inputs

extension mvvmrs_ViewModel {
    func addTodo(item: String) {
        guard !item.isEmpty else { return }
        _todoItems.value.insert(item, at: 0)
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
    
    func queryStatus() {
        _queryStatus.value = ()
    }
}

