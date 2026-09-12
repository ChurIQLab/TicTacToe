//
//  GameViewSpy.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 12.09.2026.
//

@testable import TicTacToe

final class GameViewSpy {

    // MARK: - Properties

    private(set) var events: [Event] = []
}

// MARK: - GameViewProtocol

extension GameViewSpy: GameViewProtocol {
    func showSymbol(_ symbol: String, at position: Position) {
        events.append(.showSymbol(symbol, position))
    }

    func resetBoard() {
        events.append(.resetBoard)
    }

    func showGameOver(message: String) {
        events.append(.showGameOver(message))
    }
}

// MARK: - Event

extension GameViewSpy {
    nonisolated enum Event: Equatable {
        case showSymbol(String, Position)
        case resetBoard
        case showGameOver(String)
    }
}
