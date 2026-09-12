//
//  GameView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

final class GameView: UIView {

    // MARK: - Properties

    var onCellTap: ((Position) -> Void)?

    private var buttons: [Position: UIButton] = [:]

    // MARK: - Outlets

    private let mainStackView = UIStackView()

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setSymbol(_ symbol: String, at position: Position) {
        buttons[position]?.setTitle(symbol, for: .normal)
    }

    func reset() {
        for button in buttons.values {
            button.setTitle("", for: .normal)
        }
    }

    // MARK: - Setups

    private func setupView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = Constants.buttonSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        for row in 0..<Board.size {
            let buttonRowStackView = UIStackView()
            buttonRowStackView.axis = .horizontal
            buttonRowStackView.spacing = Constants.buttonSpacing
            buttonRowStackView.distribution = .fillEqually

            for position in Position.all where position.row == row {
                let button = makeButton(for: position)
                buttons[position] = button
                buttonRowStackView.addArrangedSubview(button)
            }

            mainStackView.addArrangedSubview(buttonRowStackView)
        }

        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.widthMultiplier),
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }

    private func makeButton(for position: Position) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.addAction(UIAction { [weak self] _ in
            self?.onCellTap?(position)
        }, for: .touchUpInside)
        return button
    }
}

// MARK: - Constants

extension GameView {
    struct Constants {
        static let buttonSpacing: CGFloat = 10
        static let titleFontSize: CGFloat = 40
        static let borderWidth: CGFloat = 2
        static let widthMultiplier: CGFloat = 0.8
    }
}
