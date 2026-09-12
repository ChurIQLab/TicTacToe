//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

final class GameViewController: UIViewController {

    // MARK: - Properties

    private let presenter: GamePresenterProtocol
    private let gameView = GameView()

    // MARK: - Lifecycle

    override func loadView() {
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.onCellTap = { [weak self] position in
            self?.presenter.didTapCell(at: position)
        }
        presenter.viewDidLoad()
    }

    // MARK: - Initial

    init(presenter: GamePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GameViewProtocol

extension GameViewController: GameViewProtocol {
    func showSymbol(_ symbol: String, at position: Position) {
        gameView.setSymbol(symbol, at: position)
    }

    func resetBoard() {
        gameView.reset()
    }

    func showGameOver(message: String) {
        let alert = UIAlertController(title: "Игра окончена", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Начать новую игру", style: .default, handler: { [weak self] _ in
            self?.presenter.didTapNewGame()
        }))
        present(alert, animated: true)
    }
}
