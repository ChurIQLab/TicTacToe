//
//  Board+Diagram.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import ShapeDuel

extension Board {
    /// A board from rows like `"x.o"`: `x` — the first side, `o` — the second, `.` — a free cell
    init(_ rows: String...) throws {
        self.init()
        try #require(rows.count == Board.size)
        for (row, cells) in rows.enumerated() {
            try #require(cells.count == Board.size)
            for (column, cell) in cells.enumerated() {
                let position = try #require(Position(row: row, column: column))
                switch cell {
                case "x": place(.first, at: position)
                case "o": place(.second, at: position)
                default: break
                }
            }
        }
    }
}

extension Position {
    static func at(_ row: Int, _ column: Int) throws -> Position {
        try #require(Position(row: row, column: column))
    }
}
