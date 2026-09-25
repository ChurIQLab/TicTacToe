//
//  GameConfiguration.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// What the setup screen hands over to the game
nonisolated struct GameConfiguration: Equatable, Sendable {

    // MARK: - Properties

    let mode: GameMode
    /// Entered names without surrounding whitespace; a side without a name gets the default one
    let names: [Side: String]

    // MARK: - Initial

    init(mode: GameMode, names: [Side: String] = [:]) {
        self.mode = mode
        self.names = names
            .mapValues { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.value.isEmpty }
    }
}
