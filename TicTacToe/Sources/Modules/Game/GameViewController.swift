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
        setupNavigationBar()
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

    // MARK: - Setups

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: Typography.accent.font(),
            .foregroundColor: UIColor.primaryText
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        let restartItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.restartImageName),
            primaryAction: UIAction { [weak self] _ in
                self?.presenter.didTapNewGame()
            }
        )
        restartItem.tintColor = .primaryText
        restartItem.accessibilityLabel = String(localized: .restartButton)
        navigationItem.rightBarButtonItem = restartItem
    }
}

// MARK: - GameViewProtocol

extension GameViewController: GameViewProtocol {
    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    func showFigure(_ figure: Figure, for side: Side, at position: Position) {
        gameView.showFigure(figure, for: side, at: position)
    }

    func resetBoard() {
        gameView.reset()
    }

    func updatePlayers(_ players: [PlayerCardViewModel]) {
        gameView.updatePlayers(players)
    }

    func updateStatus(_ status: GameStatusViewModel) {
        gameView.updateStatus(status)
    }

    func showGameOver(_ result: GameResultViewModel, winningLine: WinningLineViewModel?) {
        gameView.showGameOver(winningLine: winningLine) { [weak self] in
            self?.presentResult(result)
        }
    }
}

// MARK: - Private methods

extension GameViewController {
    private func presentResult(_ result: GameResultViewModel) {
        let resultViewController = GameResultViewController(result: result) { [weak self] in
            self?.presenter.didTapNewGame()
        }
        present(resultViewController, animated: true)
    }
}

// MARK: - Constants

extension GameViewController {
    struct Constants {
        static let restartImageName = "arrow.clockwise"
    }
}
