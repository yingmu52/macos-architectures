//
//  swiftui_View.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-25.
//

import SwiftUI

struct swiftui_View: View {
    @State fileprivate var _todoItems: [swiftui_Model]
    @State fileprivate var _completedItems: [swiftui_Model ]
    @State var newItem = String()
    
    static func loadViewWithCache() -> swiftui_View {
        let cachedTodoModels: [swiftui_Model] = getCachedTodoItems().mapTodoModels()
        let cachedCompletedModels: [swiftui_Model] = getCachedCompletedItems().mapCompletedModels()
        let view = swiftui_View(_todoItems: cachedTodoModels, _completedItems: cachedCompletedModels)
        return view
    }
    
    func doubleClickedTodo(_ value: swiftui_Model) {
        if let index = _todoItems.firstIndex(where: { $0.id == value.id }) {
            let removed = _todoItems.remove(at: index)
            let newCompleted = swiftui_Model(type: .completed, content: removed.content)
            _completedItems.insert(newCompleted, at: 0)
            saveTodoModels(_todoItems)
            saveCompletedModels(_completedItems)
            return
        }
        
    }
    func doubleClickedCompleted(_ value: swiftui_Model) {
        if let index = _completedItems.firstIndex(where: { $0.id == value.id }) {
            _completedItems.remove(at: index)
            saveCompletedModels(_completedItems)
            return
        }
    }
    
    var body: some View {
        return VStack {
            ScrollView {
                ForEach(_todoItems) { value in
                    ItemCell(value: value).onTapGesture(count: 2) {
                        doubleClickedTodo(value)
                    }
                }
                .background(Color.clear)
                
                ForEach(_completedItems) { value in
                    ItemCell(value: value).onTapGesture(count: 2) {
                        doubleClickedCompleted(value)
                    }
                }
                .background(Color.clear)
            }
            .padding([.top, .leading, .trailing], 16)
            .frame(maxWidth: .infinity)
            
            Divider()
            TextField("Add new todo here", text: $newItem, onCommit: {
                if !newItem.isEmpty {
                    _todoItems.insert(.init(type: .todo, content: newItem), at: 0)
                    newItem.removeAll()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.all, 8)
        }
        .frame(minWidth: 500)
    }
}

struct ItemCell: View {
    @State var value: swiftui_Model
    
    func shouldStrikeThrough(for type: TodoType) -> Bool {
        type == .completed
    }
    
    func height(for type: TodoType) -> CGFloat {
        type == .todo ? 40 : 35
    }
    
    func backgroundColor(for type: TodoType) -> Color {
        type == .todo ? Color(.systemIndigo) : Color(.lightGray)
    }
    
    var body: some View {
        HStack {
            Text(value.content)
                .font(.system(size: 13))
                .strikethrough(shouldStrikeThrough(for: value.type))
                .padding(8)
            Spacer()
        }
        .frame(height: height(for: value.type))
        .background(backgroundColor(for: value.type))
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let todoItems: [swiftui_Model] = [
            .init(type: .todo, content: "take a look"),
            .init(type: .todo, content: "brew a cup of coffee"),
        ]
        
        let completedItems: [swiftui_Model] = [
            .init(type: .completed, content: "code 400 lines of code"),
            .init(type: .completed, content: "sleep"),
        ]
        
        let view = swiftui_View( _todoItems: todoItems, _completedItems: completedItems)
        return view
    }
}
