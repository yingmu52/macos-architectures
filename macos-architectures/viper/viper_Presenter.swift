//
//  viper_Presenter.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation

final class viper_Presenter: viper_PresenterInterface {

    var view: viper_ViewInterface
    var router: viper_RouterInterface
    
    init(view: viper_ViewInterface, router: viper_RouterInterface) {
        self.view = view
        self.router = router
    }
    
    func reloadTable() {
        view.reloadTable()
    }
}
