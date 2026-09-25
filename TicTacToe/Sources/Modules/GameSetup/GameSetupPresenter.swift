//
//  GameSetupPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

/// Only the mode title and the play button for now: names, difficulty and figures
/// come with the tasks of the modes and the figures
final class GameSetupPresenter {

    // MARK: - Properties

    weak var view: GameSetupViewProtocol?
    private let mode: GameMode
    private let router: GameSetupRouting

    // MARK: - Initial

    init(mode: GameMode, router: GameSetupRouting) {
        self.mode = mode
        self.router = router
    }
}

// MARK: - GameSetupPresenterProtocol

extension GameSetupPresenter: GameSetupPresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(mode.title)
    }

    func didTapPlay() {
        router.showGame(configuration: GameConfiguration(mode: mode))
    }
}
