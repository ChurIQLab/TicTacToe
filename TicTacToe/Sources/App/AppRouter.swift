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

    /// `nil` while the navigation controller runs a transition
    private var idleNavigationController: UINavigationController? {
        guard let navigationController, navigationController.transitionCoordinator == nil else { return nil }
        return navigationController
    }

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

    // MARK: - Private methods

    /// Builds the screen only when it is shown. A transition started while another one is running
    /// is ignored: taps on two buttons at once would otherwise stack two screens
    private func push(_ makeViewController: () -> UIViewController) {
        guard let navigationController = idleNavigationController else { return }
        navigationController.pushViewController(makeViewController(), animated: true)
    }
}

// MARK: - MenuRouting

extension AppRouter: MenuRouting {
    func showGameSetup(mode: GameMode) {
        push {
            GameSetupModuleBuilder.build(mode: mode, router: self, settings: settings)
        }
    }

    func showSettings() {
        push(SettingsModuleBuilder.build)
    }
}

// MARK: - GameSetupRouting

extension AppRouter: GameSetupRouting {
    func showGame(configuration: GameConfiguration) {
        push {
            GameModuleBuilder.build(configuration: configuration, router: self)
        }
    }
}

// MARK: - GameRouting

extension AppRouter: GameRouting {
    func showMenu() {
        idleNavigationController?.popToRootViewController(animated: true)
    }
}
