//
//  TacticalPlayerTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import TicTacToe

struct TacticalPlayerTests {

    @Test(arguments: 0..<10)
    func completesOwnLine(seed: UInt64) throws {
        let board = try Board("oo.", "xx.", "x..")
        var generator = SeededRandomNumberGenerator(seed: seed)

        let move = TacticalPlayer().move(on: board, as: .second, using: &generator)

        #expect(try move == Position.at(0, 2))
    }

    @Test(arguments: 0..<10)
    func blocksOpponentLine(seed: UInt64) throws {
        let board = try Board("xx.", ".o.", "...")
        var generator = SeededRandomNumberGenerator(seed: seed)

        let move = TacticalPlayer().move(on: board, as: .second, using: &generator)

        #expect(try move == Position.at(0, 2))
    }

    @Test(arguments: 0..<10)
    func winsRatherThanBlocks(seed: UInt64) throws {
        // Both sides have two in a row: the own line goes first
        let board = try Board("xx.", "oo.", "x..")
        var generator = SeededRandomNumberGenerator(seed: seed)

        let move = TacticalPlayer().move(on: board, as: .second, using: &generator)

        #expect(try move == Position.at(1, 2))
    }

    @Test func worksForFirstSide() throws {
        let board = try Board("oo.", "xx.", "...")
        var generator = SeededRandomNumberGenerator(seed: 1)

        let move = TacticalPlayer().move(on: board, as: .first, using: &generator)

        #expect(try move == Position.at(1, 2))
    }
}
