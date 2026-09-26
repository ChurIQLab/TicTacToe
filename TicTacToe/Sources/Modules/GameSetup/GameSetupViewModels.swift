//
//  GameSetupViewModels.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

nonisolated struct NameFieldViewModel: Equatable, Sendable {
    let side: Side
    let label: String
    let placeholder: String
    /// The name saved after the last game
    let text: String
    let maxLength: Int
}

nonisolated struct FigurePickerViewModel: Equatable, Sendable {
    let side: Side
    let selected: Figure
    /// The opponent's figure, it cannot be picked
    let taken: Figure?
}

nonisolated struct PlayerSetupViewModel: Equatable, Sendable {
    let nameField: NameFieldViewModel
    let figurePicker: FigurePickerViewModel
}

nonisolated struct DifficultyPickerViewModel: Equatable, Sendable {
    let titles: [String]
    let selectedIndex: Int
    /// Explains the selected level
    let hint: String
}

/// Against the computer: the difficulty, then the player's figures
nonisolated struct ComputerSetupViewModel: Equatable, Sendable {
    let difficultyLabel: String
    let difficulty: DifficultyPickerViewModel
    let figureLabel: String
    let figurePicker: FigurePickerViewModel
    let figureHint: String
}
