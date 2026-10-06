//
//  TacticalPlayer.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// Medium: wins if it can, otherwise blocks the opponent's line, otherwise any free cell
nonisolated struct TacticalPlayer: ComputerPlayer {
    func move(on board: Board, as side: Side, using generator: inout some RandomNumberGenerator) -> Position? {
        let winning = board.winningPositions(for: side)
        if !winning.isEmpty {
            return winning.randomElement(using: &generator)
        }

        let blocking = board.winningPositions(for: side.opponent)
        if !blocking.isEmpty {
            return blocking.randomElement(using: &generator)
        }

        return board.emptyPositions.randomElement(using: &generator)
    }
}
