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
}
