//
//  RandomPlayerTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import TicTacToe

struct RandomPlayerTests {

    @Test func movesAreSpreadOverFreeCells() {
        var generator = SeededRandomNumberGenerator(seed: 1)
        let moves = (0..<50).compactMap { _ in
            RandomPlayer().move(on: Board(), as: .second, using: &generator)
        }

        #expect(Set(moves).count > 5)
    }

    @Test func doesNotLookForWinningMove() throws {
        // The winning cell is one of five: over many seeds some moves go elsewhere
        let board = try Board("oo.", "xx.", "x..")
        let win = try Position.at(0, 2)
        var generator = SeededRandomNumberGenerator(seed: 1)
        let moves = (0..<50).compactMap { _ in
            RandomPlayer().move(on: board, as: .second, using: &generator)
        }

        #expect(moves.contains { $0 != win })
    }
}
