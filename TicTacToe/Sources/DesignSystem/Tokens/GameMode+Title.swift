//
//  GameMode+Title.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

extension GameMode {
    var title: String {
        switch self {
        case .computer: String(localized: .computerTitle)
        case .twoPlayers: String(localized: .twoPlayersTitle)
        }
    }

    var subtitle: String {
        switch self {
        case .computer: String(localized: .computerSubtitle)
        case .twoPlayers: String(localized: .twoPlayersSubtitle)
        }
    }
}
