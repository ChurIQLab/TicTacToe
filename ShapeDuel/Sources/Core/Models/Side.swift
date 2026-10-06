//
//  Side.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 11.09.2026.
//

nonisolated enum Side: CaseIterable, Sendable {
    case first
    case second

    var opponent: Side {
        switch self {
        case .first: .second
        case .second: .first
        }
    }
}
