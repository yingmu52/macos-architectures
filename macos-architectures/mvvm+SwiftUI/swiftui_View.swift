//
//  swiftui_View.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-25.
//

import SwiftUI

struct swiftui_View: View {
    @State var items: [swiftui_Model] = []
    @State var newItem = String()
    
    func getCachedItems() {
        let cachedTodoModels: [swiftui_Model] = getCachedTodoItems().mapTodoModels()
        let cachedCompletedModels: [swiftui_Model] = getCachedCompletedItems().mapCompletedModels()
        items = cachedTodoModels + cachedCompletedModels
    }
    
    var body: some View {
        return VStack {
            ScrollView {
                ForEach(items) { item in
                    HStack {
                        if item.type == .todo {
                            Text(item.content)
                                .font(.system(size: 13))
                                .padding(8)
                        } else {
                            Text(item.content)
                                .font(.system(size: 13))
                                .strikethrough()
                                .padding(8)
                        }
                        Spacer()
                    }
                    .frame(height: item.type == .todo ? 40 : 35)
                    .background(item.type == .todo ? Color(.systemIndigo) : Color(.lightGray))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .onTapGesture(count: 2, perform: {
//                        items = items.filter { $0.id != item.id }
                    })
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
        let testData: [swiftui_Model] = [
            .init(type: .todo, content: "take a look"),
            .init(type: .todo, content: "brew a cup of coffee"),
            .init(type: .todo, content: "code 400 lines of code"),
            .init(type: .completed, content: "sleep"),
        ]
        let view = swiftui_View()
        view.items = testData
        return view
    }
}
