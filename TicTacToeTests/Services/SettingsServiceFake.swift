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

    // MARK: - Initial

    init(
        twoPlayersFigures: [Side: Figure] = [.first: .cross, .second: .circle],
        computerModeFigure: Figure = .cross
    ) {
        self.twoPlayersFigures = twoPlayersFigures
        self.computerModeFigure = computerModeFigure
    }
}
