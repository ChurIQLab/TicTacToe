//
//  GamePresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

protocol GameViewDelegate: AnyObject {
    func gameView(_ gameView: GameView, didShowWinner winner: String)
}

protocol GameViewProtocol: AnyObject {
    func showWinner(_ winner: String)
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
    private var model = GameModel()
    private let engine = GameEngine()

    // MARK: - Initial

    init(view: GameViewProtocol) {
        self.view = view
        startNewGame()
    }
}

extension GamePresenter: GamePresenterProtocol {
    func playerDidTapButton(atRow row: Int, col: Int) {
        guard !model.isGameOver, model.board[row][col].isEmpty else { return }

        engine.updateBoard(in: &model, atRow: row, col: col)
        view?.updateButton(atRow: row, col: col, withTitle: model.currentPlayer.symbol)

        if let winner = engine.checkForWinner(in: model) {
            model.isGameOver = true
            view?.showWinner(winner)
        } else {
            engine.switchPlayers(in: &model)
        }
    }

    func startNewGame() {
        model = GameModel()
        view?.resetBoard()
    }
}
