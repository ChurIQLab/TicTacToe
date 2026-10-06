//
//  SettingsServiceFake.swift
//  ShapeDuelTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

@testable import ShapeDuel

/// Keeps the settings in memory
final class SettingsServiceFake: SettingsServiceProtocol {

    // MARK: - Properties

    var twoPlayersFigures: [Side: Figure]
    var computerModeFigure: Figure
    var twoPlayersNames: [Side: String]
    var computerDifficulty: Difficulty
    var theme: Theme
    var isHapticsEnabled: Bool

    // MARK: - Initial

    init(
        twoPlayersFigures: [Side: Figure] = [.first: .cross, .second: .circle],
        computerModeFigure: Figure = .cross,
        twoPlayersNames: [Side: String] = [:],
        computerDifficulty: Difficulty = .medium,
        theme: Theme = .system,
        isHapticsEnabled: Bool = true
    ) {
        self.twoPlayersFigures = twoPlayersFigures
        self.computerModeFigure = computerModeFigure
        self.twoPlayersNames = twoPlayersNames
        self.computerDifficulty = computerDifficulty
        self.theme = theme
        self.isHapticsEnabled = isHapticsEnabled
    }
}
