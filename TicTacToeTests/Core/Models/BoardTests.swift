//
//  BoardTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 11.09.2026.
//

import Testing
@testable import TicTacToe

struct BoardTests {

    @Test func newBoardIsEmpty() {
        let board = Board()

        #expect(board.emptyPositions == Position.all)
        #expect(!board.isFull)
    }

    @Test func placedSideAppearsInCell() throws {
        var board = Board()
        let cell = try #require(Position(row: 2, column: 1))

        board.place(.second, at: cell)

        #expect(board[cell] == .second)
        #expect(!board.emptyPositions.contains(cell))
        #expect(board.emptyPositions.count == 8)
    }

    @Test func boardIsFullWhenEveryCellIsTaken() {
        var board = Board()

        for position in Position.all {
            board.place(.first, at: position)
        }

        #expect(board.isFull)
        #expect(board.emptyPositions.isEmpty)
    }
}
