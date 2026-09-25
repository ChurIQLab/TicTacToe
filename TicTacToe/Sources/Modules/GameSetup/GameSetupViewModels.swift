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
