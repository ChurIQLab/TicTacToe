//
//  RandomPlayer.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// Easy: any free cell
nonisolated struct RandomPlayer: ComputerPlayer {
    func move(on board: Board, as side: Side, using generator: inout some RandomNumberGenerator) -> Position? {
        board.emptyPositions.randomElement(using: &generator)
    }
}
