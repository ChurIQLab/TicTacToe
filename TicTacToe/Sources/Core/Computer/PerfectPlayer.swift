//
//  PerfectPlayer.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// Hard: minimax with alpha-beta pruning, never loses. Among equally good moves picks a random one,
/// so games differ; a faster win and a later loss score higher
nonisolated struct PerfectPlayer: ComputerPlayer {
    func move(on board: Board, as side: Side, using generator: inout some RandomNumberGenerator) -> Position? {
        // Each first move gets an exact score: the full window keeps pruning from cutting equal moves
        let scoredMoves = board.emptyPositions.map { position in
            let score = -Self.score(
                of: board.placing(side, at: position),
                toMove: side.opponent,
                depth: 1,
                alpha: -Constants.bound,
                beta: Constants.bound
            )
            return (position: position, score: score)
        }
        guard let bestScore = scoredMoves.map(\.score).max() else { return nil }
        return scoredMoves
            .filter { $0.score == bestScore }
            .map(\.position)
            .randomElement(using: &generator)
    }

    // MARK: - Private methods

    /// Negamax: the score for the side to move; `depth` counts the moves made from the root
    private static func score(of board: Board, toMove side: Side, depth: Int, alpha: Int, beta: Int) -> Int {
        switch GameEngine.result(for: board) {
        case .win:
            // The previous move, the opponent's one, completed a line
            return depth - Constants.winScore
        case .draw:
            return 0
        case nil:
            break
        }

        var alpha = alpha
        var bestScore = -Constants.bound
        for position in board.emptyPositions {
            let score = -score(
                of: board.placing(side, at: position),
                toMove: side.opponent,
                depth: depth + 1,
                alpha: -beta,
                beta: -alpha
            )
            bestScore = max(bestScore, score)
            alpha = max(alpha, score)
            if alpha >= beta {
                break
            }
        }
        return bestScore
    }
}

// MARK: - Constants

extension PerfectPlayer {
    nonisolated struct Constants {
        /// More than the moves in a game, so a win is always above zero
        static let winScore = Board.size * Board.size + 1
        /// Beyond any score
        static let bound = winScore + 1
    }
}
