//
//  PerfectPlayerTests.swift
//  ShapeDuelTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import ShapeDuel

struct PerfectPlayerTests {

    /// Plays every possible game against the computer: the opponent tries every free cell on each move
    @Test(arguments: Side.allCases, [UInt64(1), 2, 3])
    func neverLoses(firstSide: Side, seed: UInt64) {
        var generator = SeededRandomNumberGenerator(seed: seed)
        let losses = lostGames(on: Board(), toMove: firstSide, computer: .second, generator: &generator)

        #expect(losses == 0)
    }

    @Test(arguments: 0..<10)
    func completesOwnLine(seed: UInt64) throws {
        let board = try Board("oo.", "xx.", "x..")
        var generator = SeededRandomNumberGenerator(seed: seed)

        let move = PerfectPlayer().move(on: board, as: .second, using: &generator)

        #expect(try move == Position.at(0, 2))
    }

    @Test(arguments: 0..<10)
    func blocksOpponentLine(seed: UInt64) throws {
        let board = try Board("xx.", ".o.", "...")
        var generator = SeededRandomNumberGenerator(seed: seed)

        let move = PerfectPlayer().move(on: board, as: .second, using: &generator)

        #expect(try move == Position.at(0, 2))
    }

    @Test(arguments: 0..<10)
    func blocksFork(seed: UInt64) throws {
        // Crosses in opposite corners: a corner reply lets them fork, only an edge holds the draw
        let board = try Board("x..", ".o.", "..x")
        var generator = SeededRandomNumberGenerator(seed: seed)
        let edges = try [Position.at(0, 1), Position.at(1, 0), Position.at(1, 2), Position.at(2, 1)]

        let move = try #require(PerfectPlayer().move(on: board, as: .second, using: &generator))

        #expect(edges.contains(move))
    }

    @Test func gameAgainstItselfIsDraw() throws {
        var engine = GameEngine()
        var generator = SeededRandomNumberGenerator(seed: 1)

        while engine.result == nil {
            let move = try #require(PerfectPlayer().move(on: engine.board, as: engine.currentSide, using: &generator))
            try engine.play(at: move)
        }

        #expect(engine.result == .draw)
    }

    @Test func firstMoveVariesBetweenGames() {
        let moves = (UInt64(0)..<20).compactMap { seed in
            var generator = SeededRandomNumberGenerator(seed: seed)
            return PerfectPlayer().move(on: Board(), as: .first, using: &generator)
        }

        #expect(Set(moves).count > 1)
    }
}

extension PerfectPlayerTests {

    // MARK: - Private methods

    /// Games the computer loses from this board on; the computer's random choices follow `generator`
    private func lostGames(
        on board: Board,
        toMove side: Side,
        computer: Side,
        generator: inout SeededRandomNumberGenerator
    ) -> Int {
        switch GameEngine.result(for: board) {
        case .win(let winner, _): return winner == computer ? 0 : 1
        case .draw: return 0
        case nil: break
        }

        if side == computer {
            guard let move = PerfectPlayer().move(on: board, as: side, using: &generator) else { return 0 }
            return lostGames(
                on: board.placing(side, at: move),
                toMove: side.opponent,
                computer: computer,
                generator: &generator
            )
        }

        return board.emptyPositions.reduce(0) { losses, position in
            losses + lostGames(
                on: board.placing(side, at: position),
                toMove: side.opponent,
                computer: computer,
                generator: &generator
            )
        }
    }
}
