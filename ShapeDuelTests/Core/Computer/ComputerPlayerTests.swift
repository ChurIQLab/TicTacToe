//
//  ComputerPlayerTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import ShapeDuel

struct ComputerPlayerTests {

    @Test func difficultiesHaveTheirPlayers() {
        #expect(Difficulty.easy.computerPlayer is RandomPlayer)
        #expect(Difficulty.medium.computerPlayer is TacticalPlayer)
        #expect(Difficulty.hard.computerPlayer is PerfectPlayer)
    }

    @Test(arguments: Difficulty.allCases, Side.allCases)
    func moveIsAlwaysFreeCell(difficulty: Difficulty, side: Side) throws {
        let board = try Board("xo.", ".x.", "o..")
        var generator = SeededRandomNumberGenerator(seed: 1)

        for _ in 0..<20 {
            let move = try #require(difficulty.computerPlayer.move(on: board, as: side, using: &generator))
            #expect(board[move] == nil)
        }
    }

    @Test(arguments: Difficulty.allCases)
    func fullBoardHasNoMove(difficulty: Difficulty) throws {
        let board = try Board("xox", "xoo", "oxx")
        var generator = SeededRandomNumberGenerator(seed: 1)

        #expect(difficulty.computerPlayer.move(on: board, as: .second, using: &generator) == nil)
    }

    @Test(arguments: Difficulty.allCases)
    func sameSeedGivesSameMove(difficulty: Difficulty) {
        var firstGenerator = SeededRandomNumberGenerator(seed: 7)
        var secondGenerator = SeededRandomNumberGenerator(seed: 7)
        let player = difficulty.computerPlayer

        let firstMove = player.move(on: Board(), as: .first, using: &firstGenerator)
        let secondMove = player.move(on: Board(), as: .first, using: &secondGenerator)

        #expect(firstMove == secondMove)
    }
}
