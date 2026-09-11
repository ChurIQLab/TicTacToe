//
//  PositionTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 11.09.2026.
//

import Testing
@testable import TicTacToe

struct PositionTests {

    @Test func allContainsEveryCellOnce() {
        #expect(Position.all.count == 9)
        #expect(Set(Position.all).count == 9)
    }

    @Test(arguments: [(0, 0), (1, 2), (2, 2)])
    func positionInsideBoardIsCreated(row: Int, column: Int) throws {
        let position = try #require(Position(row: row, column: column))

        #expect(position.row == row)
        #expect(position.column == column)
    }

    @Test(arguments: [(-1, 0), (0, -1), (3, 0), (0, 3)])
    func positionOutsideBoardIsNil(row: Int, column: Int) {
        #expect(Position(row: row, column: column) == nil)
    }
}
