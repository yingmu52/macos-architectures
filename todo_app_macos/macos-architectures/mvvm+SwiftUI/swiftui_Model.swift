//
//  swiftui_Model.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-25.
//

import Foundation

struct swiftui_Model: TodoModel, Identifiable {
    let id = UUID()
    let type: TodoType
    let content: String
}
