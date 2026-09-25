//
//  SettingsViewController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    private let presenter: SettingsPresenterProtocol
    private let settingsView = SettingsView()

    // MARK: - Lifecycle

    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    // MARK: - Initial

    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SettingsViewProtocol

extension SettingsViewController: SettingsViewProtocol {
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
}
