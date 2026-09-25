//
//  Side+PlayerName.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

extension Side {
    /// Shown when the player has not entered a name
    var defaultPlayerName: String {
        switch self {
        case .first: String(localized: .firstPlayerName)
        case .second: String(localized: .secondPlayerName)
        }
    }
}
