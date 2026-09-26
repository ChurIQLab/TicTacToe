//
//  SettingsServiceFake.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

@testable import TicTacToe

/// Keeps the settings in memory
final class SettingsServiceFake: SettingsServiceProtocol {

    // MARK: - Properties

    var twoPlayersFigures: [Side: Figure]
    var computerModeFigure: Figure
    var twoPlayersNames: [Side: String]

    // MARK: - Initial

    init(
        twoPlayersFigures: [Side: Figure] = [.first: .cross, .second: .circle],
        computerModeFigure: Figure = .cross,
        twoPlayersNames: [Side: String] = [:]
    ) {
        self.twoPlayersFigures = twoPlayersFigures
        self.computerModeFigure = computerModeFigure
        self.twoPlayersNames = twoPlayersNames
    }
}
