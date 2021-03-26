//
//  swiftui_View.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-25.
//

import SwiftUI

struct swiftui_Section: View {
    let type: TodoType
    @Binding var values: [swiftui_Model]
    
    func shouldStrikeThrough(for type: TodoType) -> Bool {
        type == .completed
    }
    
    func height(for type: TodoType) -> CGFloat {
        type == .todo ? 40 : 35
    }
    
    func color(for type: TodoType) -> Color {
        type == .todo ? Color(.systemIndigo) : Color(.lightGray)
    }
    
    var body: some View {
        ForEach(values) { value in
            HStack {
                Text(value.content)
                    .font(.system(size: 13))
                    .strikethrough(shouldStrikeThrough(for: value.type))
                    .padding(8)
                Spacer()
            }
            .frame(height: height(for: value.type))
            .background(color(for: value.type))
            .foregroundColor(.white)
            .cornerRadius(5)
            .onTapGesture(count: 2) {
            }
        }
        .background(Color.clear)
    }
}

struct swiftui_View: View {
    @State fileprivate var _todoItems: [swiftui_Model]
    @State fileprivate var _completedItems: [swiftui_Model]
    @State var newItem = String() {
        didSet {
            print(newItem)
        }
    }
    
    static func loadViewWithCache() -> swiftui_View {
        let cachedTodoModels: [swiftui_Model] = getCachedTodoItems().mapTodoModels()
        let cachedCompletedModels: [swiftui_Model] = getCachedCompletedItems().mapCompletedModels()
        
        let view = swiftui_View(_todoItems: cachedTodoModels, _completedItems: cachedCompletedModels)
        return view
    }
    
    var body: some View {
        return VStack {
            ScrollView {
                ForEach(_todoItems) { value in
                    HStack {
                        Text(value.content)
                            .font(.system(size: 13))
                            .padding(8)
                        Spacer()
                    }
                    .frame(height: 40)
                    .background(Color(.systemIndigo))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .onTapGesture(count: 2) {
                        if let index = _todoItems.firstIndex(where: { $0.id == value.id }) {
                            let removed = _todoItems.remove(at: index)
                            let newCompleted = swiftui_Model(type: .completed, content: removed.content)
                            _completedItems.insert(newCompleted, at: 0)
                            saveTodoModels(_todoItems)
                            saveCompletedModels(_completedItems)
                        }
                    }
                }
                .background(Color.clear)
                
                ForEach(_completedItems) { value in
                    HStack {
                        Text(value.content)
                            .font(.system(size: 13))
                            .strikethrough()
                            .padding(8)
                        Spacer()
                    }
                    .frame(height: 35)
                    .background(Color(.lightGray))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .onTapGesture(count: 2) {
                        if let index = _completedItems.firstIndex(where: { $0.id == value.id }) {
                            _completedItems.remove(at: index)
                            saveCompletedModels(_completedItems)
                        }
                    }
                }
                .background(Color.clear)
            }
            .padding([.top, .leading, .trailing], 16)
            .frame(maxWidth: .infinity)
            
            TextField("Add new todo here", text: $newItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
        }
        .frame(minWidth: 500)
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
