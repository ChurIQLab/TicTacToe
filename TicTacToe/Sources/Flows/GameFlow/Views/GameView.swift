//
//  GameView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

final class GameView: UIView {

    // MARK: - Properties

    private let gridSize: Int = 3
    weak var delegate: GameViewDelegate?
    var buttons: [[UIButton]] = []

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

    // MARK: - Setups

    private func setupView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = Constants.buttonSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<gridSize {
            let buttonRowStackView = UIStackView()
            buttonRowStackView.axis = .horizontal
            buttonRowStackView.spacing = Constants.buttonSpacing
            buttonRowStackView.distribution = .fillEqually

            var buttonRow: [UIButton] = []
            for _ in 0..<gridSize {
                let button = UIButton(type: .system)
                button.setTitle("", for: .normal)
                button.backgroundColor = .lightGray
                button.titleLabel?.font = .systemFont(ofSize: Constants.titleFontSize)
                button.setTitleColor(.black, for: .normal)
                button.layer.borderWidth = Constants.borderWidth
                button.layer.borderColor = UIColor.black.cgColor
                button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
                buttonRow.append(button)
                buttonRowStackView.addArrangedSubview(button)
            }

            buttons.append(buttonRow)
            mainStackView.addArrangedSubview(buttonRowStackView)
        }

        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.widthMultiplier),
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor),
        ])
    }
}

// MARK: - GameViewProtocol

extension GameView: GameViewProtocol {
    func showWinner(_ winner: String) {
        delegate?.gameView(self, didShowWinner: winner)
    }

    func updateButton(atRow row: Int, col: Int, withTitle title: String) {
        buttons[row][col].setTitle(title, for: .normal)
    }

    func resetBoard() {
        for row in buttons {
            for button in row {
                button.setTitle("", for: .normal)
            }
        }
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
