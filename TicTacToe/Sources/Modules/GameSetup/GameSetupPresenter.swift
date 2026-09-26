//
//  GameSetupPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// Names and figures of the players; difficulty comes with the computer mode
final class GameSetupPresenter {

    // MARK: - Properties

    weak var view: GameSetupViewProtocol?
    private let mode: GameMode
    private let router: GameSetupRouting
    /// Raw field text: `GameConfiguration` trims it and drops empty names
    private var names: [Side: String] = [:]
    /// Against the computer only the player's figure, the first side; the computer gets another one
    private var figures: [Side: Figure]

    // MARK: - Initial

    init(mode: GameMode, router: GameSetupRouting, settings: SettingsServiceProtocol) {
        self.mode = mode
        self.router = router
        figures = switch mode {
        case .computer: [.first: settings.computerModeFigure]
        case .twoPlayers: settings.twoPlayersFigures
        }
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
        router.showGame(configuration: GameConfiguration(mode: mode, names: names, figures: figures))
    }
}
