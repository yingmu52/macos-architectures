//
//  ArchitectureSelector.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Cocoa

class SelectorViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
   
    struct Pattern {
        let name: String
        let storyboardName: String
    }
    var selectPattern: ((Pattern) -> Void)?

    var patterns: [Pattern] = [
        .init(name: "MVC", storyboardName: "mvc_View"),
        .init(name: "MVVM + ReactiveSwift", storyboardName: "mvvmrs_View"),
        .init(name: "MVVM + RxSwift", storyboardName: "mvvmrx_View")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setupTheme()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.action = #selector(singleClick)
        
        tableView.selectRowIndexes([0], byExtendingSelection: false)
    }
    
    @objc func singleClick() {
        let pattern = patterns[tableView.selectedRow]
        selectPattern?(pattern)
    }
}

extension SelectorViewController: NSTableViewDelegate, NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat { 50 }
    
    func numberOfRows(in tableView: NSTableView) -> Int { patterns.count }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("SelectorCell")
        guard let cell = tableView.makeView(withIdentifier: id, owner: nil) as? NSTableCellView else { return nil }
        cell.focusRingType = .exterior
        cell.textField?.stringValue = patterns[row].name
        cell.textField?.textColor = .black
        return cell
    }
}
