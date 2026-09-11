//
//  GameResult.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 11.09.2026.
//

nonisolated enum GameResult: Equatable, Sendable {
    case win(Side, line: [Position])
    case draw
}
