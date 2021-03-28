//
//  swiftui_View.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-25.
//

import SwiftUI

struct swiftui_View: View {
    @ObservedObject var viewModel = swiftui_ViewModel()
    @State var currentEditingText = String()
    var onReceivedWindowTitle: ((String) -> Void) = { _ in }
    
    static func loadViewWithCache(
        todoModels: [swiftui_Model] = getCachedTodoItems().mapTodoModels(),
        completedModels: [swiftui_Model] = getCachedCompletedItems().mapCompletedModels()
    ) -> swiftui_View {
        
        let vm = swiftui_ViewModel()
        vm.todoItems = todoModels
        vm.completedItems = completedModels
        let view = swiftui_View(viewModel: vm)
        return view
    }
    
    var body: some View {
        onReceivedWindowTitle(viewModel.outputs.status)
        
        return VStack {
            ScrollView {
                ForEach(viewModel.outputs.todoItems) { item in
                    swiftui_ItemCell(value: item).onTapGesture(count: 2) { [viewModel] in
                        viewModel.inputs.removeTodo(item: item)
                    }
                }
                .background(Color.clear)

                ForEach(viewModel.outputs.completedItems) { item in
                    swiftui_ItemCell(value: item).onTapGesture(count: 2) { [ viewModel] in
                        viewModel.inputs.removeCompleted(item: item)
                    }
                }
                .background(Color.clear)
            }
            .padding([.top, .leading, .trailing], 16)
            .frame(maxWidth: .infinity)
            
            TextField("Add new todo here", text: $currentEditingText, onCommit: {
                viewModel.inputs.addTodo(item: currentEditingText)
                currentEditingText.removeAll()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.all, 8)
        }
        .frame(minWidth: 500)
    }
}

struct swiftui_ItemCell: View {
    @State var value: swiftui_Model
    
    var body: some View {
        HStack {
            Text(value.content)
                .font(.system(size: 13))
                .strikethrough(shouldStrikeThrough)
                .padding(8)
            Spacer()
        }
        .frame(height: height)
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(5)
        .animation(.easeInOut)
    }
    
    var shouldStrikeThrough: Bool {
        value.type == .completed
    }
    
    var height: CGFloat {
        value.type == .todo ? 40 : 35
    }
    
    var backgroundColor: Color {
        value.type == .todo ? Color(.systemIndigo) : Color(.lightGray)
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
        
        let view = swiftui_View.loadViewWithCache(todoModels: todoItems, completedModels: completedItems)
        return view
    }
}
