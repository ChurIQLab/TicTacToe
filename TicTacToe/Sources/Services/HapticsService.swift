//
//  HapticsService.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import UIKit

protocol HapticsServiceProtocol: AnyObject {
    func playMove()
    func playWin()
    func playDraw()
}

final class HapticsService {

    // MARK: - Properties

    private let moveGenerator = UIImpactFeedbackGenerator(style: .light)
    private let resultGenerator = UINotificationFeedbackGenerator()
}

// MARK: - HapticsServiceProtocol

extension HapticsService: HapticsServiceProtocol {
    func playMove() {
        moveGenerator.impactOccurred()
    }

    func playWin() {
        resultGenerator.notificationOccurred(.success)
    }

    func playDraw() {
        resultGenerator.notificationOccurred(.warning)
    }
}
