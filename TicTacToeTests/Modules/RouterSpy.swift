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
    func showGame(mode: GameMode) {
        events.append(.showGame(mode))
    }

    func showSettings() {
        events.append(.showSettings)
    }
}

// MARK: - Event

extension RouterSpy {
    nonisolated enum Event: Equatable {
        case showGame(GameMode)
        case showSettings
    }
}
