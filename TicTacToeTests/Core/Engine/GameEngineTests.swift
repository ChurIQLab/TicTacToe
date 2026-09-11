//
//  GameEngineTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 11.09.2026.
//

import Testing
@testable import TicTacToe

struct GameEngineTests {

    @Test func thereAreEightWinningLines() throws {
        let expectedLines = try [
            [(0, 0), (0, 1), (0, 2)],
            [(1, 0), (1, 1), (1, 2)],
            [(2, 0), (2, 1), (2, 2)],
            [(0, 0), (1, 0), (2, 0)],
            [(0, 1), (1, 1), (2, 1)],
            [(0, 2), (1, 2), (2, 2)],
            [(0, 0), (1, 1), (2, 2)],
            [(0, 2), (1, 1), (2, 0)]
        ].map { try positions($0) }

        #expect(GameEngine.winningLines.count == 8)
        #expect(Set(GameEngine.winningLines) == Set(expectedLines))
    }

    @Test(arguments: Side.allCases)
    func sidesAlternateAfterEachMove(firstSide: Side) throws {
        var engine = GameEngine(firstSide: firstSide)
        let firstMove = try position(0, 0)
        let secondMove = try position(1, 1)
        #expect(engine.currentSide == firstSide)

        try engine.play(at: firstMove)
        #expect(engine.currentSide == firstSide.opponent)

        try engine.play(at: secondMove)
        #expect(engine.currentSide == firstSide)
        #expect(engine.board[firstMove] == firstSide)
        #expect(engine.board[secondMove] == firstSide.opponent)
        #expect(engine.result == nil)
    }

    @Test(arguments: Side.allCases, GameEngine.winningLines)
    func sideWinsByCompletingLine(firstSide: Side, line: [Position]) throws {
        var engine = GameEngine(firstSide: firstSide)
        let otherCells = Position.all.filter { !line.contains($0) }

        try play([line[0], otherCells[0], line[1], otherCells[1], line[2]], in: &engine)

        #expect(engine.result == .win(firstSide, line: line))
    }

    @Test func fullBoardWithoutLineIsDraw() throws {
        var engine = GameEngine()
        let moves = try positions([(0, 0), (0, 1), (0, 2), (1, 1), (1, 0), (1, 2), (2, 1), (2, 0), (2, 2)])

        try play(moves, in: &engine)

        #expect(engine.result == .draw)
    }

    @Test func moveToOccupiedCellThrows() throws {
        var engine = GameEngine()
        let cell = try position(1, 1)
        try engine.play(at: cell)
        let boardBefore = engine.board

        #expect(throws: GameEngine.MoveError.cellOccupied) {
            try engine.play(at: cell)
        }
        #expect(engine.board == boardBefore)
        #expect(engine.currentSide == .second)
    }

    @Test func moveAfterGameOverThrows() throws {
        var engine = GameEngine()
        try play(positions([(0, 0), (1, 0), (0, 1), (1, 1), (0, 2)]), in: &engine)
        let cell = try position(2, 2)
        let boardBefore = engine.board

        #expect(throws: GameEngine.MoveError.gameOver) {
            try engine.play(at: cell)
        }
        #expect(engine.board == boardBefore)
    }
}

extension GameEngineTests {

    // MARK: - Private methods

    private func position(_ row: Int, _ column: Int) throws -> Position {
        try #require(Position(row: row, column: column))
    }

    private func positions(_ cells: [(Int, Int)]) throws -> [Position] {
        try cells.map { row, column in try position(row, column) }
    }

    private func play(_ moves: [Position], in engine: inout GameEngine) throws {
        for move in moves {
            try engine.play(at: move)
        }
    }
}
