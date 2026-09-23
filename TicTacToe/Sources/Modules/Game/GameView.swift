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

    func showFigure(_ figure: Figure, for side: Side, at position: Position) {
        cells[position]?.showFigure(figure, color: side.color)
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
    private let figureView = FigureView()
    private var figureSizeConstraint: NSLayoutConstraint?

    // MARK: - Initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func showFigure(_ figure: Figure, color: UIColor) {
        figureView.show(figure, color: color, animated: true)
        accessibilityLabel = figure.accessibilityName
    }

    func clear() {
        figureView.show(nil, color: .clear)
        accessibilityLabel = nil
    }

    func apply(_ heightClass: HeightClass) {
        cardView.cornerRadius = CornerRadius.cell(for: heightClass)
        figureSizeConstraint?.constant = Size.figureInCell(for: heightClass)
    }

    // MARK: - Setups

    private func setupView() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        cardView.isUserInteractionEnabled = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        figureView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)
        addSubview(figureView)

        let figureSizeConstraint = figureView.widthAnchor.constraint(equalToConstant: Size.figureInCell(for: .regular))
        self.figureSizeConstraint = figureSizeConstraint
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            figureView.centerXAnchor.constraint(equalTo: centerXAnchor),
            figureView.centerYAnchor.constraint(equalTo: centerYAnchor),
            figureView.heightAnchor.constraint(equalTo: figureView.widthAnchor),
            figureSizeConstraint
        ])

        apply(.regular)
    }
}
