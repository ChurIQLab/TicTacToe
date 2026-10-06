//
//  AppearanceService.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 04.10.2026.
//

import UIKit

protocol AppearanceServiceProtocol: AnyObject {
    /// `animated` cross-fades the whole window into the new theme
    func apply(_ theme: Theme, animated: Bool)
}

/// Sets the theme on the window: every screen, sheet, alert and the keyboard inherit it
final class AppearanceService {

    // MARK: - Properties

    /// The scene owns the window, the service only styles it
    private weak var window: UIWindow?

    // MARK: - Initial

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Private methods

    private func interfaceStyle(for theme: Theme) -> UIUserInterfaceStyle {
        switch theme {
        case .system: .unspecified
        case .light: .light
        case .dark: .dark
        }
    }
}

// MARK: - AppearanceServiceProtocol

extension AppearanceService: AppearanceServiceProtocol {
    func apply(_ theme: Theme, animated: Bool) {
        guard let window else { return }
        let style = interfaceStyle(for: theme)
        guard animated else {
            window.overrideUserInterfaceStyle = style
            return
        }
        UIView.transition(
            with: window,
            duration: Constants.transitionDuration,
            options: [.transitionCrossDissolve, .allowUserInteraction]
        ) {
            window.overrideUserInterfaceStyle = style
        }
    }
}

// MARK: - Constants

extension AppearanceService {
    struct Constants {
        static let transitionDuration: TimeInterval = 0.3
    }
}
