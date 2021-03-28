//
//  Pattern.swift
//  macos-architectures
//
//  Created by Xinyi Zhuang on 2021-03-27.
//

import Foundation

enum Pattern: CaseIterable {
    case mvc
    case viper
    case mvvm_ReactiveSwift
    case mvvm_RxSwift
    case mvvm_swiftui
}

extension Pattern: CustomStringConvertible {
    var description: String {
        switch self {
        case .mvc: return "MVC"
        case .viper: return "VIPER"
        case .mvvm_ReactiveSwift: return "MVVM + ReactiveSwift"
        case .mvvm_RxSwift: return "MVVM + RxSwift"
        case .mvvm_swiftui: return "MVVM + SwiftUI"
        }
    }
}

extension Pattern {
    var storyboardName: String {
        switch self {
        case .mvc: return "mvc_View"
        case .viper: return "viper_View"
        case .mvvm_ReactiveSwift: return "mvvmrs_View"
        case .mvvm_RxSwift: return "mvvmrx_View"
        case .mvvm_swiftui: return ""
        }
    }
}
