//
//  HapticsServiceSpy.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 23.09.2026.
//

@testable import TicTacToe

final class HapticsServiceSpy {

    // MARK: - Properties

    private(set) var events: [Event] = []
}

// MARK: - HapticsServiceProtocol

extension HapticsServiceSpy: HapticsServiceProtocol {
    func playMove() {
        events.append(.move)
    }

    func playWin() {
        events.append(.win)
    }

    func playDraw() {
        events.append(.draw)
    }
}

// MARK: - Event

extension HapticsServiceSpy {
    nonisolated enum Event: Equatable {
        case move
        case win
        case draw
    }
}
