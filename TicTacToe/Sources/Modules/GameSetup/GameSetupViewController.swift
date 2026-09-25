//
//  GameSetupViewController.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

final class GameSetupViewController: UIViewController {

    // MARK: - Properties

    private let presenter: GameSetupPresenterProtocol
    private let setupView = GameSetupView()

    // MARK: - Lifecycle

    override func loadView() {
        view = setupView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView.onPlayTap = { [weak self] in
            self?.presenter.didTapPlay()
        }
        presenter.viewDidLoad()
    }

    // MARK: - Initial

    init(presenter: GameSetupPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GameSetupViewProtocol

extension GameSetupViewController: GameSetupViewProtocol {
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
}
