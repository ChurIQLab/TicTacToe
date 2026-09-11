//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

nonisolated struct GameEngine: Sendable {

    // MARK: - Properties

    static let winningLines: [[Position]] = {
        let range = 0..<Board.size
        let rows = range.map { row in Position.all.filter { $0.row == row } }
        let columns = range.map { column in Position.all.filter { $0.column == column } }
        let diagonal = Position.all.filter { $0.row == $0.column }
        let antiDiagonal = Position.all.filter { $0.row + $0.column == Board.size - 1 }
        return rows + columns + [diagonal, antiDiagonal]
    }()

    private(set) var board = Board()
    private(set) var currentSide: Side
    private(set) var result: GameResult?

    // MARK: - Initial

    init(firstSide: Side = .first) {
        currentSide = firstSide
    }

    // MARK: - Methods

    mutating func play(at position: Position) throws(MoveError) {
        guard result == nil else { throw MoveError.gameOver }
        guard board[position] == nil else { throw MoveError.cellOccupied }

        board.place(currentSide, at: position)
        result = Self.result(for: board)

        if result == nil {
            currentSide = currentSide.opponent
        }
    }

    static func result(for board: Board) -> GameResult? {
        for line in winningLines {
            guard
                let start = line.first,
                let side = board[start],
                line.allSatisfy({ board[$0] == side })
            else { continue }
            return .win(side, line: line)
        }
        return board.isFull ? .draw : nil
    }
}

// MARK: - MoveError

extension GameEngine {
    nonisolated enum MoveError: Error, Equatable {
        case cellOccupied
        case gameOver
    }
}
