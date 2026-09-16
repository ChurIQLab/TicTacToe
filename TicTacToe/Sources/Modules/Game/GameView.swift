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

    private var cells: [Position: BoardCell] = [:]
    private var heightClass: HeightClass?

    // MARK: - Outlets

    private let mainStackView = UIStackView()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateHeightClass()
    }

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setSymbol(_ symbol: String, for side: Side, at position: Position) {
        cells[position]?.setSymbol(symbol, color: side.color)
    }

    func reset() {
        for cell in cells.values {
            cell.clear()
        }
    }

    // MARK: - Setups

    private func setupView() {
        backgroundColor = .screenBackground

        mainStackView.axis = .vertical
        mainStackView.spacing = Spacing.betweenCells
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        for row in 0..<Board.size {
            let cellRowStackView = UIStackView()
            cellRowStackView.axis = .horizontal
            cellRowStackView.spacing = Spacing.betweenCells
            cellRowStackView.distribution = .fillEqually

            for position in Position.all where position.row == row {
                let cell = makeCell(for: position)
                cells[position] = cell
                cellRowStackView.addArrangedSubview(cell)
            }

            mainStackView.addArrangedSubview(cellRowStackView)
        }

        addSubview(mainStackView)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Spacing.screenMargin),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Spacing.screenMargin),
            mainStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }

    private func makeCell(for position: Position) -> BoardCell {
        let cell = BoardCell()
        cell.heightAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        cell.addAction(UIAction { [weak self] _ in
            self?.onCellTap?(position)
        }, for: .touchUpInside)
        return cell
    }

    // MARK: - Private methods

    private func updateHeightClass() {
        guard !bounds.isEmpty else { return }
        let newHeightClass = HeightClass(screenHeight: bounds.height)
        guard newHeightClass != heightClass else { return }
        heightClass = newHeightClass
        for cell in cells.values {
            cell.apply(newHeightClass)
        }
    }
}

// MARK: - BoardCell

private final class BoardCell: UIControl {

    // MARK: - Outlets

    private let cardView = CardView(cornerRadius: CornerRadius.cell(for: .regular))
    private let symbolLabel = UILabel()

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setSymbol(_ symbol: String, color: UIColor) {
        symbolLabel.text = symbol
        symbolLabel.textColor = color
        accessibilityLabel = symbol
    }

    func clear() {
        symbolLabel.text = nil
        accessibilityLabel = nil
    }

    func apply(_ heightClass: HeightClass) {
        cardView.cornerRadius = CornerRadius.cell(for: heightClass)
        symbolLabel.font = .rounded(ofSize: Size.figureInCell(for: heightClass), weight: .heavy)
    }

    // MARK: - Setups

    private func setupView() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        cardView.isUserInteractionEnabled = false
        symbolLabel.textAlignment = .center

        for subview in [cardView, symbolLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        apply(.regular)
    }
}
