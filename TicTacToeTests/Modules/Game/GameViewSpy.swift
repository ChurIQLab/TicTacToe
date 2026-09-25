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

    /// Board changes and the game over, without the updates of the surrounding panels
    var boardEvents: [Event] {
        events.filter { event in
            switch event {
            case .showFigure, .resetBoard, .showGameOver: true
            case .setTitle, .updatePlayers, .updateStatus: false
            }
        }
    }

    var status: GameStatusViewModel? {
        for case .updateStatus(let status) in events.reversed() {
            return status
        }
        return nil
    }

    var result: GameResultViewModel? {
        for case .showGameOver(let result, _) in events.reversed() {
            return result
        }
        return nil
    }

    var players: [PlayerCardViewModel] {
        for case .updatePlayers(let players) in events.reversed() {
            return players
        }
        return []
    }
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

    func updatePlayers(_ players: [PlayerCardViewModel]) {
        events.append(.updatePlayers(players))
    }

    func updateStatus(_ status: GameStatusViewModel) {
        events.append(.updateStatus(status))
    }

    func showGameOver(_ result: GameResultViewModel, winningLine: WinningLineViewModel?) {
        events.append(.showGameOver(result, winningLine))
    }
}

// MARK: - Event

extension GameViewSpy {
    nonisolated enum Event: Equatable {
        case setTitle(String)
        case showFigure(Figure, Side, Position)
        case resetBoard
        case updatePlayers([PlayerCardViewModel])
        case updateStatus(GameStatusViewModel)
        case showGameOver(GameResultViewModel, WinningLineViewModel?)
    }
}
