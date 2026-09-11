//
//  GamePresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

protocol GameViewDelegate: AnyObject {
    func gameView(_ gameView: GameView, didFinishGameWithMessage message: String)
}

protocol GameViewProtocol: AnyObject {
    func showGameOver(message: String)
    func updateButton(atRow row: Int, col: Int, withTitle title: String)
    func resetBoard()
}

protocol GamePresenterProtocol: AnyObject {
    func playerDidTapButton(atRow row: Int, col: Int)
    func startNewGame()
}

final class GamePresenter {

    // MARK: - Properties

    weak var view: GameViewProtocol?
    private var engine = GameEngine()

    // MARK: - Initial

    init(view: GameViewProtocol) {
        self.view = view
        startNewGame()
    }

    // MARK: - Private methods

    private func symbol(for side: Side) -> String {
        switch side {
        case .first: "X"
        case .second: "O"
        }
    }

    private func name(for side: Side) -> String {
        switch side {
        case .first: "Player 1"
        case .second: "Player 2"
        }
    }

    private func message(for result: GameResult) -> String {
        switch result {
        case .win(let side, _): "Победитель: \(name(for: side))"
        case .draw: "Ничья"
        }
    }
}

extension GamePresenter: GamePresenterProtocol {
    func playerDidTapButton(atRow row: Int, col: Int) {
        guard let position = Position(row: row, column: col) else { return }
        let side = engine.currentSide

        do {
            try engine.play(at: position)
        } catch {
            return
        }

        view?.updateButton(atRow: row, col: col, withTitle: symbol(for: side))

        if let result = engine.result {
            view?.showGameOver(message: message(for: result))
        }
    }

    func startNewGame() {
        engine = GameEngine()
        view?.resetBoard()
    }
}
