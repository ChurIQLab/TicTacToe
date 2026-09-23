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
    func setTitle(_ title: String) {
        events.append(.setTitle(title))
    }

    func showFigure(_ figure: Figure, for side: Side, at position: Position) {
        events.append(.showFigure(figure, side, position))
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
        case setTitle(String)
        case showFigure(Figure, Side, Position)
        case resetBoard
        case showGameOver(String)
    }
}
