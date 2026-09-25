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

    // MARK: - Initial

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Methods

    func start() {
        let menuViewController = MenuModuleBuilder.build(router: self)
        navigationController?.setViewControllers([menuViewController], animated: false)
    }
}

// MARK: - MenuRouting

extension AppRouter: MenuRouting {
    func showGame(mode: GameMode) {
        navigationController?.pushViewController(GameModuleBuilder.build(mode: mode), animated: true)
    }

    func showSettings() {
        navigationController?.pushViewController(SettingsModuleBuilder.build(), animated: true)
    }
}
