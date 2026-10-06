//
//  ComputerMoveScheduler.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 03.10.2026.
//

import Foundation

/// Gives the computer's move after a pause, so the player sees it «thinking».
/// Tests replace it with a fake that hands the move over on demand
protocol ComputerMoveScheduling: AnyObject {
    /// Replaces a scheduled move; `completion` gets `nil` when the board has no free cell
    func scheduleMove(
        on board: Board,
        as side: Side,
        by player: any ComputerPlayer,
        completion: @escaping (Position?) -> Void
    )
    /// The scheduled move is dropped and `completion` is not called
    func cancel()
}

final class ComputerMoveScheduler {

    // MARK: - Properties

    private var task: Task<Void, Never>?
}

// MARK: - ComputerMoveScheduling

extension ComputerMoveScheduler: ComputerMoveScheduling {
    func scheduleMove(
        on board: Board,
        as side: Side,
        by player: any ComputerPlayer,
        completion: @escaping (Position?) -> Void
    ) {
        cancel()
        task = Task {
            // The move is picked off the main thread while the pause runs
            async let move = Self.pickMove(on: board, as: side, by: player)
            try? await Task.sleep(for: Constants.delay)
            let position = await move
            guard !Task.isCancelled else { return }
            completion(position)
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}

// MARK: - Private methods

extension ComputerMoveScheduler {
    @concurrent
    nonisolated private static func pickMove(
        on board: Board,
        as side: Side,
        by player: any ComputerPlayer
    ) async -> Position? {
        var generator = SystemRandomNumberGenerator()
        return player.move(on: board, as: side, using: &generator)
    }
}

// MARK: - Constants

extension ComputerMoveScheduler {
    struct Constants {
        static let delay: Duration = .milliseconds(600)
    }
}
