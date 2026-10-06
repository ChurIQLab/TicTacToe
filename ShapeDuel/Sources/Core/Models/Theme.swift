//
//  Theme.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 04.10.2026.
//

/// Raw values are stored in the settings, so they must not change
nonisolated enum Theme: String, CaseIterable, Sendable {
    /// Follows the light or dark appearance of the system
    case system
    case light
    case dark
}
