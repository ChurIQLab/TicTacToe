//
//  LocalizationTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 12.09.2026.
//

import Foundation
import Testing

struct LocalizationTests {

    @Test func russianHasEveryEnglishKey() throws {
        let englishKeys = try keys(for: "en")
        let russianKeys = try keys(for: "ru")

        #expect(!englishKeys.isEmpty)
        #expect(russianKeys == englishKeys)
    }
}

extension LocalizationTests {

    // MARK: - Private methods

    private func keys(for language: String) throws -> Set<String> {
        let url = try #require(Bundle.main.url(
            forResource: "Localizable",
            withExtension: "strings",
            subdirectory: nil,
            localization: language
        ))
        let table = try #require(NSDictionary(contentsOf: url) as? [String: String])
        return Set(table.keys)
    }
}
