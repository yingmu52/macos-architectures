//
//  viper_Interactor.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-26.
//

import Foundation

final class viper_Interactor: viper_InteractorInterface {

    let presenter: viper_PresenterInterface
    let dataSource: DataSource<viper_Entity>
    
    init(presenter: viper_PresenterInterface, dataSource: DataSource<viper_Entity>) {
        self.presenter = presenter
        self.dataSource = dataSource
    }

    func loadData() {
        presenter.reloadTable()
    }
}
