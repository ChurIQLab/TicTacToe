//
//  Position.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 11.09.2026.
//

nonisolated struct Position: Hashable, Sendable {

    // MARK: - Properties

    static let all: [Position] = (0..<Board.size).flatMap { row in
        (0..<Board.size).map { column in
            Position(uncheckedRow: row, column: column)
        }
    }

    let row: Int
    let column: Int

    // MARK: - Initial

    init?(row: Int, column: Int) {
        let range = 0..<Board.size
        guard range.contains(row), range.contains(column) else { return nil }
        self.init(uncheckedRow: row, column: column)
    }

    private init(uncheckedRow row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
