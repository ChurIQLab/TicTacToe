//
//  ComputerPlayer.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// Picks the computer's move. The random choices come from `generator`,
/// so tests get the same moves for the same seed
nonisolated protocol ComputerPlayer: Sendable {
    /// `nil` when the board has no free cell
    func move(on board: Board, as side: Side, using generator: inout some RandomNumberGenerator) -> Position?
}

// MARK: - Difficulty

nonisolated extension Difficulty {
    var computerPlayer: any ComputerPlayer {
        switch self {
        case .easy: RandomPlayer()
        case .medium: TacticalPlayer()
        case .hard: PerfectPlayer()
        }
    }
}

// MARK: - Board

nonisolated extension Board {
    func placing(_ side: Side, at position: Position) -> Board {
        var board = self
        board.place(side, at: position)
        return board
    }

    /// Free cells where `side` completes a line
    func winningPositions(for side: Side) -> [Position] {
        emptyPositions.filter { position in
            guard case .win = GameEngine.result(for: placing(side, at: position)) else { return false }
            return true
        }
    }
}
