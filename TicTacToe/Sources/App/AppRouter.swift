//
//  AppRouter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

/// Performs every transition between screens. Modules get it through their builders
/// as a narrow routing protocol and call it from the presenter
final class AppRouter {

    // MARK: - Properties

    /// The window owns the navigation controller, the router only drives it
    private weak var navigationController: UINavigationController?
    private let settings: SettingsServiceProtocol

    // MARK: - Initial

    init(navigationController: UINavigationController, settings: SettingsServiceProtocol) {
        self.navigationController = navigationController
        self.settings = settings
    }

    // MARK: - Methods

    func start() {
        let menuViewController = MenuModuleBuilder.build(router: self)
        navigationController?.setViewControllers([menuViewController], animated: false)
    }
}

// MARK: - MenuRouting

extension AppRouter: MenuRouting {
    func showGameSetup(mode: GameMode) {
        let gameSetupViewController = GameSetupModuleBuilder.build(
            mode: mode,
            router: self,
            settings: settings
        )
        navigationController?.pushViewController(gameSetupViewController, animated: true)
    }

    func showSettings() {
        navigationController?.pushViewController(SettingsModuleBuilder.build(), animated: true)
    }
}

// MARK: - GameSetupRouting

extension AppRouter: GameSetupRouting {
    func showGame(configuration: GameConfiguration) {
        let gameViewController = GameModuleBuilder.build(configuration: configuration, router: self)
        navigationController?.pushViewController(gameViewController, animated: true)
    }
}

// MARK: - GameRouting

extension AppRouter: GameRouting {
    func showMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
}
