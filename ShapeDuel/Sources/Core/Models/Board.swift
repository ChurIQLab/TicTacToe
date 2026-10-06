//
//  Board.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 11.09.2026.
//

nonisolated struct Board: Equatable, Sendable {

    // MARK: - Properties

    static let size = 3

    var emptyPositions: [Position] {
        Position.all.filter { self[$0] == nil }
    }

    var isFull: Bool {
        !cells.contains(nil)
    }

    private var cells: [Side?] = Array(repeating: nil, count: Board.size * Board.size)

    // MARK: - Methods

    subscript(position: Position) -> Side? {
        cells[index(of: position)]
    }

    mutating func place(_ side: Side, at position: Position) {
        cells[index(of: position)] = side
    }

    // MARK: - Private methods

    private func index(of position: Position) -> Int {
        position.row * Self.size + position.column
    }
}
