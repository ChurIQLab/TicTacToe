//
//  GameStatusViewModelTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct GameStatusViewModelTests {

    @Test func nameAfterPhraseIsFound() {
        let status = GameStatusViewModel(side: .first, figure: .cross, name: "Аня") { "Ходит \($0)" }

        #expect(status.text == "Ходит Аня")
        #expect(status.player?.nameRange == NSRange(location: 6, length: 3))
    }

    @Test func nameRepeatingWordOfPhraseKeepsItsPlace() {
        let status = GameStatusViewModel(side: .second, figure: .circle, name: "Ход") { "Ходит \($0)" }

        #expect(status.text == "Ходит Ход")
        #expect(status.player?.nameRange == NSRange(location: 6, length: 3))
    }

    @Test func nameBeforePhraseIsFound() {
        let status = GameStatusViewModel(side: .first, figure: .cross, name: "turn") { "\($0)'s turn" }

        #expect(status.text == "turn's turn")
        #expect(status.player?.nameRange == NSRange(location: 0, length: 4))
    }

    @Test func emojiNameRangeCoversWholeEmoji() throws {
        let name = "👩‍👩‍👧 Аня"
        let status = GameStatusViewModel(side: .first, figure: .cross, name: name) { "Победа: \($0)" }

        let nameRange = try #require(status.player?.nameRange)
        #expect((status.text as NSString).substring(with: nameRange) == name)
    }

    @Test func phraseWithoutNameHasNoPlayer() {
        let status = GameStatusViewModel(side: .first, figure: .cross, name: "Аня") { _ in "Ничья" }

        #expect(status == GameStatusViewModel(text: "Ничья", player: nil))
    }
}
