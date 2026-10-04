//
//  AppearanceServiceSpy.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 04.10.2026.
//

@testable import TicTacToe

final class AppearanceServiceSpy: AppearanceServiceProtocol {

    // MARK: - Properties

    private(set) var appliedThemes: [AppliedTheme] = []

    // MARK: - AppearanceServiceProtocol

    func apply(_ theme: Theme, animated: Bool) {
        appliedThemes.append(AppliedTheme(theme: theme, animated: animated))
    }
}

// MARK: - AppliedTheme

extension AppearanceServiceSpy {
    struct AppliedTheme: Equatable {
        let theme: Theme
        let animated: Bool
    }
}
