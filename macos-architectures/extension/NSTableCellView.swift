//
//  NSTableCellView.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-23.
//

import Cocoa

extension NSTableCellView {
    func setup(content: String, for todoType: mvc_Model.Section) {
        // set cell style
        wantsLayer = true
        layer?.cornerRadius = 5
        textField?.textColor = .white
        
        switch todoType {
        case .todo:
            layer?.backgroundColor = NSColor.systemIndigo.cgColor
            textField?.attributedStringValue = NSAttributedString(string: content, attributes: [
                .foregroundColor: NSColor.white,
            ])
        case .completed:
            layer?.backgroundColor = NSColor.lightGray.cgColor
            textField?.attributedStringValue = NSAttributedString(string: content, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: NSColor.black,
                .foregroundColor: NSColor.white,
            ])
        }
    }
}
