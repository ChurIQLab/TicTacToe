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

    // MARK: - Initial

    /// A prepared generator plays without a delay, so both are prepared again after every use
    init() {
        prepareGenerators()
    }

    // MARK: - Private methods

    private func prepareGenerators() {
        moveGenerator.prepare()
        resultGenerator.prepare()
    }
}

// MARK: - HapticsServiceProtocol

extension HapticsService: HapticsServiceProtocol {
    func playMove() {
        moveGenerator.impactOccurred()
        prepareGenerators()
    }

    func playWin() {
        resultGenerator.notificationOccurred(.success)
        prepareGenerators()
    }

    func playDraw() {
        resultGenerator.notificationOccurred(.warning)
        prepareGenerators()
    }
}
