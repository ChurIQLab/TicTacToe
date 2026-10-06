//
//  NavigationController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

/// System navigation bar on every screen: transparent, rounded title, back button without text
final class NavigationController: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.forEach(hideBackButtonTitle)
        super.setViewControllers(viewControllers, animated: animated)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        hideBackButtonTitle(of: viewController)
        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - Setups

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: Typography.accent.font(),
            .foregroundColor: UIColor.primaryText
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .primaryText
    }

    // MARK: - Private methods

    private func hideBackButtonTitle(of viewController: UIViewController) {
        viewController.navigationItem.backButtonDisplayMode = .minimal
    }
}
