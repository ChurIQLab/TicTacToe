//
//  Difficulty+Title.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Foundation

extension Difficulty {
    var title: String {
        switch self {
        case .easy: String(localized: .easyDifficulty)
        case .medium: String(localized: .mediumDifficulty)
        case .hard: String(localized: .hardDifficulty)
        }
    }

    /// What the computer does at this level
    var hint: String {
        switch self {
        case .easy: String(localized: .easyDifficultyHint)
        case .medium: String(localized: .mediumDifficultyHint)
        case .hard: String(localized: .hardDifficultyHint)
        }
    }
}
