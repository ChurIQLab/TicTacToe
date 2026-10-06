//
//  GameSetupPresenter.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// Names and figures of the players, the difficulty against the computer
final class GameSetupPresenter {

    // MARK: - Properties

    weak var view: GameSetupViewProtocol?
    private let mode: GameMode
    private let router: GameSetupRouting
    private let settings: SettingsServiceProtocol
    /// Raw field text: `GameConfiguration` trims it and drops empty names
    private var names: [Side: String] = [:]
    /// Against the computer only the player's figure, the first side; the computer gets another one
    private var figures: [Side: Figure]
    private var difficulty: Difficulty

    /// Sides whose figures the player picks on the screen
    private var pickingSides: [Side] {
        switch mode {
        case .computer: [.first]
        case .twoPlayers: Side.allCases
        }
    }

    // MARK: - Initial

    init(mode: GameMode, router: GameSetupRouting, settings: SettingsServiceProtocol) {
        self.mode = mode
        self.router = router
        self.settings = settings
        if mode == .twoPlayers {
            names = settings.twoPlayersNames
        }
        figures = switch mode {
        case .computer: [.first: settings.computerModeFigure]
        case .twoPlayers: settings.twoPlayersFigures
        }
        difficulty = settings.computerDifficulty
    }

    // MARK: - Private methods

    private func nameField(for side: Side) -> NameFieldViewModel {
        NameFieldViewModel(
            side: side,
            label: side.defaultPlayerName,
            placeholder: side.defaultPlayerName,
            text: names[side] ?? "",
            maxLength: GameConfiguration.maxNameLength
        )
    }

    private func figurePicker(for side: Side) -> FigurePickerViewModel {
        FigurePickerViewModel(
            side: side,
            selected: figures[side] ?? Figure.defaultFigure(for: side),
            taken: figures[side.opponent]
        )
    }

    private var difficultyPicker: DifficultyPickerViewModel {
        DifficultyPickerViewModel(
            titles: Difficulty.allCases.map(\.title),
            selectedIndex: Difficulty.allCases.firstIndex(of: difficulty) ?? 0,
            hint: difficulty.hint
        )
    }

    private func save(_ configuration: GameConfiguration) {
        switch mode {
        case .computer:
            if let figure = configuration.figures[.first] {
                settings.computerModeFigure = figure
            }
            settings.computerDifficulty = configuration.difficulty
        case .twoPlayers:
            settings.twoPlayersFigures = configuration.figures
            settings.twoPlayersNames = configuration.names
        }
    }
}

// MARK: - GameSetupPresenterProtocol

extension GameSetupPresenter: GameSetupPresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(mode.title)
        switch mode {
        case .computer:
            view?.showComputerSetup(ComputerSetupViewModel(
                difficultyLabel: String(localized: .difficultyLabel),
                difficulty: difficultyPicker,
                figureLabel: String(localized: .yourFigureLabel),
                figurePicker: figurePicker(for: .first),
                figureHint: String(localized: .computerFigureHint)
            ))
        case .twoPlayers:
            let players = Side.allCases.map { side in
                PlayerSetupViewModel(nameField: nameField(for: side), figurePicker: figurePicker(for: side))
            }
            view?.showPlayers(players, hint: String(localized: .twoPlayersSetupHint))
        }
    }

    func didChangeName(_ name: String, for side: Side) {
        names[side] = name
    }

    func didSelectFigure(_ figure: Figure, for side: Side) {
        guard pickingSides.contains(side), figure != figures[side.opponent], figure != figures[side] else { return }
        figures[side] = figure
        view?.updateFigurePickers(pickingSides.map(figurePicker))
    }

    func didSelectDifficulty(at index: Int) {
        guard mode == .computer, Difficulty.allCases.indices.contains(index) else { return }
        let selected = Difficulty.allCases[index]
        guard selected != difficulty else { return }
        difficulty = selected
        view?.updateDifficultyPicker(difficultyPicker)
    }

    func didTapPlay() {
        let configuration = GameConfiguration(mode: mode, names: names, figures: figures, difficulty: difficulty)
        save(configuration)
        router.showGame(configuration: configuration)
    }
}
