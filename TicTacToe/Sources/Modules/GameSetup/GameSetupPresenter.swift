//
//  GameSetupPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// Names for two players; difficulty and figures come with the tasks of the computer mode and the figures
final class GameSetupPresenter {

    // MARK: - Properties

    weak var view: GameSetupViewProtocol?
    private let mode: GameMode
    private let router: GameSetupRouting
    /// Raw field text: `GameConfiguration` trims it and drops empty names
    private var names: [Side: String] = [:]

    // MARK: - Initial

    init(mode: GameMode, router: GameSetupRouting) {
        self.mode = mode
        self.router = router
    }

    // MARK: - Private methods

    private func nameField(for side: Side) -> NameFieldViewModel {
        NameFieldViewModel(
            side: side,
            label: side.defaultPlayerName,
            placeholder: side.defaultPlayerName,
            maxLength: GameConfiguration.maxNameLength
        )
    }
}

// MARK: - GameSetupPresenterProtocol

extension GameSetupPresenter: GameSetupPresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(mode.title)
        guard mode == .twoPlayers else { return }
        view?.showNameFields(Side.allCases.map(nameField), hint: String(localized: .namesHint))
    }

    func didChangeName(_ name: String, for side: Side) {
        names[side] = name
    }

    func didTapPlay() {
        router.showGame(configuration: GameConfiguration(mode: mode, names: names))
    }
}
