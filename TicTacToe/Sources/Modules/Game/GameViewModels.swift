//
//  GameViewModels.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

nonisolated struct PlayerCardViewModel: Equatable, Sendable {
    let side: Side
    let figure: Figure
    let name: String
    let score: Int
    let state: State
}

// MARK: - State

extension PlayerCardViewModel {
    nonisolated enum State: Equatable, Sendable {
        /// Moves now or has just won
        case active
        case inactive
        /// Nobody is highlighted after a draw
        case neutral
    }
}
