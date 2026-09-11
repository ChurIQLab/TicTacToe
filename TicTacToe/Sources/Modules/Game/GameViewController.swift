//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

final class GameViewController: UIViewController {

    // MARK: - Properties

    private let gameView: GameView
    private let presenter: GamePresenterProtocol

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupButtonActions()
        gameView.delegate = self
    }

    // MARK: - Initial

    init(presenter: GamePresenterProtocol, gameView: GameView) {
        self.presenter = presenter
        self.gameView = gameView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func configureView() {
        view.addSubview(gameView)
        gameView.frame = view.bounds
        gameView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupButtonActions() {
        for row in 0..<3 {
            for col in 0..<3 {
                let button = gameView.buttons[row][col]
                button.addAction(UIAction { [weak self] _ in
                    self?.handleButtonTapped(button)
                }, for: .touchUpInside)
            }
        }
    }

    private func handleButtonTapped(_ sender: UIButton) {
        guard
            let buttonIndex = gameView.buttons.flatMap({ $0 }).firstIndex(of: sender)
        else { return }
        let row = buttonIndex / 3
        let col = buttonIndex % 3
        presenter.playerDidTapButton(atRow: row, col: col)
    }
}

// MARK: - GameViewDelegate

extension GameViewController: GameViewDelegate {
    func gameView(_ gameView: GameView, didShowWinner winner: String) {
        let alert = UIAlertController(title: "Игра окончена", message: "Победитель: \(winner)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Начать новую игру", style: .default, handler: { [weak self] _ in
            self?.presenter.startNewGame()
        }))
        present(alert, animated: true)
    }
}
