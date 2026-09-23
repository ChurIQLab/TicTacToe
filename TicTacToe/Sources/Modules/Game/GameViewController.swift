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
    func showFigure(_ figure: Figure, for side: Side, at position: Position) {
        gameView.showFigure(figure, for: side, at: position)
    }

    func resetBoard() {
        gameView.reset()
    }

    func showGameOver(message: String) {
        let alert = UIAlertController(
            title: String(localized: .gameOverTitle),
            message: message,
            preferredStyle: .alert
        )
        let newGameAction = UIAlertAction(title: String(localized: .newGameButton), style: .default) { [weak self] _ in
            self?.presenter.didTapNewGame()
        }
        alert.addAction(newGameAction)
        present(alert, animated: true)
    }
}
