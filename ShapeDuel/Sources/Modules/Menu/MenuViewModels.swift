//
//  MenuViewModels.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

nonisolated struct MenuItemViewModel: Equatable, Sendable {
    let mode: GameMode
    let title: String
    let subtitle: String
}
