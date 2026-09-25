//
//  GameSetupView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

final class GameSetupView: UIView {

    // MARK: - Properties

    var onPlayTap: (() -> Void)?

    // MARK: - Outlets

    private let playButton = CapsuleButton(title: String(localized: .playButton), style: .primary)

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    private func setupView() {
        backgroundColor = .screenBackground

        playButton.addAction(UIAction { [weak self] _ in
            self?.onPlayTap?()
        }, for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Spacing.screenMargin),
            playButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Spacing.screenMargin),
            playButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
