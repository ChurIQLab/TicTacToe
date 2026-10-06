//
//  ComputerMoveSchedulerFake.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 03.10.2026.
//

@testable import ShapeDuel

/// Keeps the scheduled move until the test hands it over, so no test waits for the pause
final class ComputerMoveSchedulerFake {

    // MARK: - Properties

    private(set) var scheduledSides: [Side] = []
    private(set) var lastPlayer: (any ComputerPlayer)?
    private(set) var cancelCount = 0
    private var pendingMove: PendingMove?

    var hasPendingMove: Bool {
        pendingMove != nil
    }

    // MARK: - Methods

    /// The move the scheduled player picks with a fixed seed
    func runPendingMove(seed: UInt64 = 1) {
        guard let pendingMove else { return }
        self.pendingMove = nil
        var generator = SeededRandomNumberGenerator(seed: seed)
        pendingMove.completion(pendingMove.player.move(on: pendingMove.board, as: pendingMove.side, using: &generator))
    }

    /// A chosen move instead of the player's one, e.g. to let the computer win
    func completePendingMove(at position: Position) {
        guard let pendingMove else { return }
        self.pendingMove = nil
        pendingMove.completion(position)
    }
}

// MARK: - ComputerMoveScheduling

extension ComputerMoveSchedulerFake: ComputerMoveScheduling {
    func scheduleMove(
        on board: Board,
        as side: Side,
        by player: any ComputerPlayer,
        completion: @escaping (Position?) -> Void
    ) {
        scheduledSides.append(side)
        lastPlayer = player
        pendingMove = PendingMove(board: board, side: side, player: player, completion: completion)
    }

    func cancel() {
        cancelCount += 1
        pendingMove = nil
    }
}

// MARK: - PendingMove

extension ComputerMoveSchedulerFake {
    private struct PendingMove {
        let board: Board
        let side: Side
        let player: any ComputerPlayer
        let completion: (Position?) -> Void
    }
}
