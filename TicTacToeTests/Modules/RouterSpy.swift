//
//  RouterSpy.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

@testable import TicTacToe

final class RouterSpy {

    // MARK: - Properties

    private(set) var events: [Event] = []
}

// MARK: - MenuRouting

extension RouterSpy: MenuRouting {
    func showGameSetup(mode: GameMode) {
        events.append(.showGameSetup(mode))
    }

    func showSettings() {
        events.append(.showSettings)
    }
}

// MARK: - GameSetupRouting

extension RouterSpy: GameSetupRouting {
    func showGame(mode: GameMode) {
        events.append(.showGame(mode))
    }
}

// MARK: - GameRouting

extension RouterSpy: GameRouting {
    func showMenu() {
        events.append(.showMenu)
    }
}

// MARK: - Event

extension RouterSpy {
    nonisolated enum Event: Equatable {
        case showGameSetup(GameMode)
        case showSettings
        case showGame(GameMode)
        case showMenu
    }
}
