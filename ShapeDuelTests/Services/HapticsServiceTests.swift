//
//  HapticsServiceTests.swift
//  ShapeDuelTests
//
//  Created by Churkin Vitaly on 04.10.2026.
//

import Testing
import UIKit
@testable import ShapeDuel

struct HapticsServiceTests {

    // MARK: - Properties

    private let settings = SettingsServiceFake()
    private let moveGenerator = ImpactGeneratorSpy()
    private let resultGenerator = NotificationGeneratorSpy()

    // MARK: - Tests

    @Test func enabledHapticsPlayEveryEvent() {
        let haptics = makeService()

        haptics.playMove()
        haptics.playWin()
        haptics.playDraw()
        haptics.playLoss()

        #expect(moveGenerator.impacts == 1)
        #expect(resultGenerator.notifications == [.success, .warning, .error])
    }

    @Test func disabledHapticsPlayNothing() {
        settings.isHapticsEnabled = false
        let haptics = makeService()

        haptics.playMove()
        haptics.playWin()
        haptics.playDraw()
        haptics.playLoss()

        #expect(moveGenerator.impacts == 0)
        #expect(resultGenerator.notifications.isEmpty)
    }

    @Test func disabledHapticsDoNotPrepareGenerators() {
        settings.isHapticsEnabled = false

        _ = makeService()

        #expect(moveGenerator.preparations == 0)
        #expect(resultGenerator.preparations == 0)
    }

    @Test func settingChangeAppliesToExistingService() {
        let haptics = makeService()

        settings.isHapticsEnabled = false
        haptics.playMove()
        settings.isHapticsEnabled = true
        haptics.playMove()

        #expect(moveGenerator.impacts == 1)
    }

    @Test func generatorsArePreparedAgainAfterUse() {
        let haptics = makeService()

        haptics.playWin()

        #expect(moveGenerator.preparations == 2)
        #expect(resultGenerator.preparations == 2)
    }
}

extension HapticsServiceTests {

    // MARK: - Private methods

    private func makeService() -> HapticsService {
        HapticsService(settings: settings, moveGenerator: moveGenerator, resultGenerator: resultGenerator)
    }
}

// MARK: - ImpactGeneratorSpy

private final class ImpactGeneratorSpy: ImpactFeedbackGenerating {

    // MARK: - Properties

    private(set) var preparations = 0
    private(set) var impacts = 0

    // MARK: - ImpactFeedbackGenerating

    func prepare() {
        preparations += 1
    }

    func impactOccurred() {
        impacts += 1
    }
}

// MARK: - NotificationGeneratorSpy

private final class NotificationGeneratorSpy: NotificationFeedbackGenerating {

    // MARK: - Properties

    private(set) var preparations = 0
    private(set) var notifications: [UINotificationFeedbackGenerator.FeedbackType] = []

    // MARK: - NotificationFeedbackGenerating

    func prepare() {
        preparations += 1
    }

    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        notifications.append(notificationType)
    }
}
