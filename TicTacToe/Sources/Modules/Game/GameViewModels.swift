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

// MARK: - GameStatusViewModel

nonisolated struct GameStatusViewModel: Equatable, Sendable {
    let text: String
    /// The player named in `text`: the name is highlighted and preceded by the figure
    let player: Player?
}

extension GameStatusViewModel {
    nonisolated struct Player: Equatable, Sendable {
        let side: Side
        let figure: Figure
        let name: String
    }
}
