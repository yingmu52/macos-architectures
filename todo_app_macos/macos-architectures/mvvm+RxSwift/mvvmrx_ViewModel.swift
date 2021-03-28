//
//  mvvmrx_ViewModel.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Foundation
import RxSwift
import RxCocoa

protocol mvvmrx_ViewModelInputs {
    func addTodo(item: String)
    func clicked(at index: Int)
    func queryStatus()
}

protocol mvvmrx_ViewModelOutputs {
    var items: Observable<[mvvmrx_Model]> { get }
    var status: Observable<String> { get }
}

protocol mvvmrx_ViewModelType {
    var inputs: mvvmrx_ViewModelInputs { get }
    var outputs: mvvmrx_ViewModelOutputs { get }
}

class mvvmrx_ViewModel: mvvmrx_ViewModelType, mvvmrx_ViewModelOutputs {

    var inputs: mvvmrx_ViewModelInputs { self }
    var outputs: mvvmrx_ViewModelOutputs { self }
    
    private let _todoItems = BehaviorRelay(value: getCachedTodoItems())
    private let _completedItems = BehaviorRelay(value: getCachedCompletedItems())
    private let _queryStatus = BehaviorRelay(value: ())
    private let bag = DisposeBag()
    
    let items: Observable<[mvvmrx_Model]>
    let status: Observable<String>

    init() {
        items = BehaviorRelay.combineLatest(_todoItems, _completedItems).map { items in
            let (todoItems, completedItems) = items
            return todoItems.mapTodoModels() + completedItems.mapCompletedModels()
        }
        
        status = BehaviorRelay.combineLatest(_todoItems, _completedItems, _queryStatus).map { items in
            let (todoItems, completedItems, _) = items
            return "[MVVM + RxSwift] \(todoItems.count) todo \(completedItems.count) completed"
        }
        
        _todoItems.asObservable().subscribe(onNext: { items in
            saveTodoItems(items)
        })
        .disposed(by: bag)
        
        _completedItems.asObservable().subscribe(onNext: { items in
            saveCompletedItems(items)
        })
        .disposed(by: bag)
    }
}

extension mvvmrx_ViewModel: mvvmrx_ViewModelInputs {
    func addTodo(item: String) {
        guard !item.isEmpty else { return }
        var currentItems = _todoItems.value
        currentItems.insert(item, at: 0)
        _todoItems.accept(currentItems)
    }
    
    func clicked(at index: Int) {
        if 0 ..< _todoItems.value.count ~= index {
            var currentTodoItems = _todoItems.value
            let removedItems = currentTodoItems.remove(at: index)
            var currentCompleteItems = _completedItems.value
            currentCompleteItems.insert(removedItems, at: 0)
            _todoItems.accept(currentTodoItems)
            _completedItems.accept(currentCompleteItems)
        }
            
        if 0 ..< _completedItems.value.count ~= index - _todoItems.value.count {
            var currentCompleteItems = _completedItems.value
            currentCompleteItems.remove(at: index - _todoItems.value.count)
            _completedItems.accept(currentCompleteItems)
        }
    }
    
    func queryStatus() {
        _queryStatus.accept(())
    }
}
