//
//  SettingsServiceTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

/// Each test gets its own empty settings domain, removed afterwards
final class SettingsServiceTests {

    // MARK: - Properties

    private let suiteName = "SettingsServiceTests.\(UUID().uuidString)"
    private let defaults: UserDefaults

    // MARK: - Initial

    init() throws {
        defaults = try #require(UserDefaults(suiteName: suiteName))
    }

    /// `deinit` is nonisolated and cannot touch `defaults`, any instance removes the domain by name
    deinit {
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
    }

    // MARK: - Tests

    @Test func emptySettingsGiveDefaultFigures() {
        let settings = SettingsService(defaults: defaults)

        #expect(settings.twoPlayersFigures == [.first: .cross, .second: .circle])
        #expect(settings.computerModeFigure == .cross)
    }

    @Test func twoPlayersFiguresAreKeptBetweenLaunches() {
        SettingsService(defaults: defaults).twoPlayersFigures = [.first: .star, .second: .heart]

        #expect(SettingsService(defaults: defaults).twoPlayersFigures == [.first: .star, .second: .heart])
    }

    @Test func computerModeFigureIsKeptBetweenLaunches() {
        SettingsService(defaults: defaults).computerModeFigure = .hexagon

        #expect(SettingsService(defaults: defaults).computerModeFigure == .hexagon)
    }

    @Test func computerModeFigureDoesNotChangeTwoPlayersFigures() {
        let settings = SettingsService(defaults: defaults)

        settings.computerModeFigure = .circle

        #expect(settings.twoPlayersFigures == [.first: .cross, .second: .circle])
    }

    @Test func storedSameFiguresAreMadeDistinct() {
        defaults.set("star", forKey: SettingsService.Constants.twoPlayersFirstFigureKey)
        defaults.set("star", forKey: SettingsService.Constants.twoPlayersSecondFigureKey)

        #expect(SettingsService(defaults: defaults).twoPlayersFigures == [.first: .star, .second: .cross])
    }

    @Test func unknownStoredFigureFallsBackToDefault() {
        defaults.set("pentagon", forKey: SettingsService.Constants.twoPlayersFirstFigureKey)
        defaults.set("pentagon", forKey: SettingsService.Constants.computerModeFigureKey)
        let settings = SettingsService(defaults: defaults)

        #expect(settings.twoPlayersFigures == [.first: .cross, .second: .circle])
        #expect(settings.computerModeFigure == .cross)
    }

    @Test func namesAreKeptBetweenLaunches() {
        SettingsService(defaults: defaults).twoPlayersNames = [.first: "Аня", .second: "Макс"]

        #expect(SettingsService(defaults: defaults).twoPlayersNames == [.first: "Аня", .second: "Макс"])
    }

    @Test func nameWithoutValueIsRemoved() {
        let settings = SettingsService(defaults: defaults)
        settings.twoPlayersNames = [.first: "Аня", .second: "Макс"]

        settings.twoPlayersNames = [.second: "Макс"]

        #expect(settings.twoPlayersNames == [.second: "Макс"])
    }
}
