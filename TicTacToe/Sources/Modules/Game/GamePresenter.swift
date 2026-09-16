//
//  GamePresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

final class GamePresenter {

    // MARK: - Properties

    weak var view: GameViewProtocol?
    private var engine = GameEngine()

    // MARK: - Private methods

    private func startNewGame() {
        engine = GameEngine()
        view?.resetBoard()
    }

    private func symbol(for side: Side) -> String {
        switch side {
        case .first: "X"
        case .second: "O"
        }
    }

    private func name(for side: Side) -> String {
        switch side {
        case .first: String(localized: .firstPlayerName)
        case .second: String(localized: .secondPlayerName)
        }
    }

    private func message(for result: GameResult) -> String {
        switch result {
        case .win(let side, _): String(localized: .winnerMessage(name(for: side)))
        case .draw: String(localized: .drawMessage)
        }
    }
}

// MARK: - GamePresenterProtocol

extension GamePresenter: GamePresenterProtocol {
    func viewDidLoad() {
        startNewGame()
    }

    func didTapCell(at position: Position) {
        let side = engine.currentSide

        do {
            try engine.play(at: position)
        } catch {
            return
        }

        view?.showSymbol(symbol(for: side), for: side, at: position)

        if let result = engine.result {
            view?.showGameOver(message: message(for: result))
        }
    }

    func didTapNewGame() {
        startNewGame()
    }
}
