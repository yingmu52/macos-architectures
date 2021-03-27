//
//  SplitViewController.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-24.
//

import Cocoa
import SwiftUI

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectorViewController = splitViewItems.first?.viewController as? SelectorViewController {
            
            selectorViewController.selectPattern = { [weak self] pattern in
                
                self?.splitViewItems.removeLast()
                
                if pattern.storyboardName == "" {
                    var view = swiftui_View.loadViewWithCache()
                    view.onReceivedWindowTitle = { [weak self] title in
                        self?.view.window?.title = title
                    }
                    let vc = NSHostingController(rootView: view)
                    self?.splitViewItems.append(NSSplitViewItem(viewController: vc))
                    return
                }
                
                let storyboard = NSStoryboard(name: pattern.storyboardName, bundle: nil)
                
                if let vc = storyboard.instantiateInitialController() as? NSViewController {
                    self?.splitViewItems.append(NSSplitViewItem(viewController: vc))
                    (vc as? SplitViewControllerSelectionProtocol)?.setWindowTitle()
                }
            }
        }
    }
}

protocol SplitViewControllerSelectionProtocol {
    func setWindowTitle()
}
