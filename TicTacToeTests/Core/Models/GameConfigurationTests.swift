//
//  GameConfigurationTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Testing
@testable import TicTacToe

struct GameConfigurationTests {

    @Test func namesAreTrimmed() {
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: "  Аня\n", .second: "Макс"])

        #expect(configuration.names == [.first: "Аня", .second: "Макс"])
    }

    @Test(arguments: ["", "   ", " \n\t "])
    func blankNameIsDropped(name: String) {
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: name, .second: "Макс"])

        #expect(configuration.names == [.second: "Макс"])
    }

    @Test func spacesInsideNameAreKept() {
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: " Анна Мария "])

        #expect(configuration.names == [.first: "Анна Мария"])
    }

    @Test func longNameIsCutToMaxLength() {
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: "Александра Константиновна"])

        #expect(configuration.names[.first] == "Александра Конст")
    }

    @Test func cutNameDoesNotEndWithSpace() {
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: "Максимилианович Иван"])

        #expect(configuration.names[.first] == "Максимилианович")
    }

    @Test func emojiCountsAsOneCharacter() {
        let name = String(repeating: "👩‍👩‍👧", count: GameConfiguration.maxNameLength)
        let configuration = GameConfiguration(mode: .twoPlayers, names: [.first: name])

        #expect(configuration.names[.first] == name)
    }
}
