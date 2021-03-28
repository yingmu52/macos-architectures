//
//  NSTableView.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-23.
//

import Cocoa

extension NSTableView {
    
    func setupTheme() {
        // use signal column
        columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        sizeLastColumnToFit()
        
        // remove header view
        headerView = nil
        
        // remove table view selection color
        selectionHighlightStyle = .sourceList
        
        // add space between cell
        intercellSpacing = NSSize(width: 5, height: 5)
    }
}
