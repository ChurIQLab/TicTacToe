//
//  Theme+Title.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 04.10.2026.
//

import Foundation

extension Theme {
    var title: String {
        switch self {
        case .system: String(localized: .systemTheme)
        case .light: String(localized: .lightTheme)
        case .dark: String(localized: .darkTheme)
        }
    }
}
