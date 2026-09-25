//
//  MenuViewController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

final class MenuViewController: UIViewController {

    // MARK: - Properties

    private let presenter: MenuPresenterProtocol
    private let menuView = MenuView()

    // MARK: - Lifecycle

    override func loadView() {
        view = menuView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        menuView.onItemTap = { [weak self] mode in
            self?.presenter.didSelectMode(mode)
        }
        presenter.viewDidLoad()
    }

    // MARK: - Initial

    init(presenter: MenuPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    private func setupNavigationBar() {
        let settingsItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.settingsImageName),
            primaryAction: UIAction { [weak self] _ in
                self?.presenter.didTapSettings()
            }
        )
        settingsItem.accessibilityLabel = String(localized: .settingsTitle)
        navigationItem.rightBarButtonItem = settingsItem
    }
}

// MARK: - MenuViewProtocol

extension MenuViewController: MenuViewProtocol {
    func showItems(_ items: [MenuItemViewModel]) {
        menuView.showItems(items)
    }
}

// MARK: - Constants

extension MenuViewController {
    struct Constants {
        static let settingsImageName = "slider.horizontal.3"
    }
}
