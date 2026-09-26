//
//  Figure.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

/// Raw values are stored in the settings, so they must not change
nonisolated enum Figure: String, CaseIterable, Sendable {
    case cross
    case circle
    case triangle
    case square
    case diamond
    case star
    case heart
    case hexagon
}
