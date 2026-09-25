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

    /// In characters as the user sees them, so an emoji counts as one
    static let maxNameLength = 16

    let mode: GameMode
    /// Entered names without surrounding whitespace and cut to `maxNameLength`;
    /// a side without a name gets the default one
    let names: [Side: String]

    // MARK: - Initial

    init(mode: GameMode, names: [Side: String] = [:]) {
        self.mode = mode
        self.names = names
            .mapValues(Self.normalizedName)
            .filter { !$0.value.isEmpty }
    }

    // MARK: - Private methods

    /// Trims again after cutting so the name does not end with a space
    private static func normalizedName(_ name: String) -> String {
        String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(maxNameLength))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
