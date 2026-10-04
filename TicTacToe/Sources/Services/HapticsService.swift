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
    /// The computer has won
    func playLoss()
}

/// What the service needs from `UIImpactFeedbackGenerator`, so tests can count the taps
protocol ImpactFeedbackGenerating: AnyObject {
    func prepare()
    func impactOccurred()
}

/// What the service needs from `UINotificationFeedbackGenerator`
protocol NotificationFeedbackGenerating: AnyObject {
    func prepare()
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType)
}

extension UIImpactFeedbackGenerator: ImpactFeedbackGenerating {}
extension UINotificationFeedbackGenerator: NotificationFeedbackGenerating {}

/// Plays nothing while haptics are off in the settings; the setting is read on every call,
/// so a change applies at once
final class HapticsService {

    // MARK: - Properties

    private let settings: SettingsServiceProtocol
    private let moveGenerator: ImpactFeedbackGenerating
    private let resultGenerator: NotificationFeedbackGenerating

    // MARK: - Initial

    /// A prepared generator plays without a delay, so both are prepared again after every use
    init(
        settings: SettingsServiceProtocol,
        moveGenerator: ImpactFeedbackGenerating = UIImpactFeedbackGenerator(style: .light),
        resultGenerator: NotificationFeedbackGenerating = UINotificationFeedbackGenerator()
    ) {
        self.settings = settings
        self.moveGenerator = moveGenerator
        self.resultGenerator = resultGenerator
        prepareGenerators()
    }

    // MARK: - Private methods

    private func prepareGenerators() {
        guard settings.isHapticsEnabled else { return }
        moveGenerator.prepare()
        resultGenerator.prepare()
    }

    private func playResult(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        guard settings.isHapticsEnabled else { return }
        resultGenerator.notificationOccurred(notificationType)
        prepareGenerators()
    }
}

// MARK: - HapticsServiceProtocol

extension HapticsService: HapticsServiceProtocol {
    func playMove() {
        guard settings.isHapticsEnabled else { return }
        moveGenerator.impactOccurred()
        prepareGenerators()
    }

    func playWin() {
        playResult(.success)
    }

    func playDraw() {
        playResult(.warning)
    }

    func playLoss() {
        playResult(.error)
    }
}
