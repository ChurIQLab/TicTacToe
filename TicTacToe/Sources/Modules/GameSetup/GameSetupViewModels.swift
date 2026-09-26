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
