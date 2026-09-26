//
//  SettingsService.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Foundation

protocol SettingsServiceProtocol: AnyObject {
    /// Always different for the two sides
    var twoPlayersFigures: [Side: Figure] { get set }
    /// The player's figure in the computer mode; the player is the first side
    var computerModeFigure: Figure { get set }
}

/// Keeps the choices of the setup screens between launches
final class SettingsService {

    // MARK: - Properties

    private let defaults: UserDefaults

    // MARK: - Initial

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Private methods

    /// `nil` for a missing value and for a figure the app no longer has
    private func figure(forKey key: String) -> Figure? {
        defaults.string(forKey: key).flatMap(Figure.init(rawValue:))
    }

    private func figureKey(for side: Side) -> String {
        switch side {
        case .first: Constants.twoPlayersFirstFigureKey
        case .second: Constants.twoPlayersSecondFigureKey
        }
    }
}

// MARK: - SettingsServiceProtocol

extension SettingsService: SettingsServiceProtocol {
    var twoPlayersFigures: [Side: Figure] {
        get {
            let figures = Side.allCases.reduce(into: [Side: Figure]()) { figures, side in
                figures[side] = figure(forKey: figureKey(for: side))
            }
            return Figure.distinctFigures(figures)
        }
        set {
            for (side, figure) in Figure.distinctFigures(newValue) {
                defaults.set(figure.rawValue, forKey: figureKey(for: side))
            }
        }
    }

    var computerModeFigure: Figure {
        get { figure(forKey: Constants.computerModeFigureKey) ?? Figure.defaultFigure(for: .first) }
        set { defaults.set(newValue.rawValue, forKey: Constants.computerModeFigureKey) }
    }
}

// MARK: - Constants

extension SettingsService {
    /// Stored in the user's settings, so they must not change
    struct Constants {
        static let twoPlayersFirstFigureKey = "twoPlayers.firstFigure"
        static let twoPlayersSecondFigureKey = "twoPlayers.secondFigure"
        static let computerModeFigureKey = "computer.playerFigure"
    }
}
