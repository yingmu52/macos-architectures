//
//  DataSource.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Foundation
import Cocoa

/*
 although NSTableViewDelegate shouldn't be here, some of the datasource-like methods are in NSTableViewDelegate
 for example `cellForRowAt` is a method in UITableViewDataSource see https://developer.apple.com/documentation/uikit/uitableviewdatasource
 but apparently `viewFor tableColumn:` isn't in NSTableViewDataSource :(
*/

class DataSource<Value: TodoModel>: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    private var values: [Value]

    init(_ values: [Value]) {
        self.values = values
    }
    
    func bind(to tableView: NSTableView) {
        tableView.delegate = self // see the above comment :(
        tableView.dataSource = self
    }
    
    func setValues(_ items: [Value]) {
        values = items
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        values.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        values[row].type == .todo ? 40 : 35
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier(rawValue: "TodoItemCell")
        guard let cell = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView else { return nil }
        let item = values[row]
        cell.setup(content: item.content, for: item.type)
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
}

extension DataSource {
    
    var status: String {
        var todoCount = 0, completedCount = 0
        for item in values {
            switch item.type {
            case .todo:
                todoCount += 1
            case .completed:
                completedCount += 1
            }
        }
        return "\(todoCount) todo \(completedCount) completed"
    }
    
    @discardableResult
    func remove(at index: Int) -> Value {
        values.remove(at: index)
    }
    
    func insert(_ value: Value, at index: Int) {
        values.insert(value, at: 0)
    }
    
    func getType(at index: Int) -> TodoType {
        values[index].type
    }
    
}
