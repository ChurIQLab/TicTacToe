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
    private var playerCards: [Side: PlayerCardView] = [:]
    private var playerCardHeightConstraints: [NSLayoutConstraint] = []
    private var heightClass: HeightClass?

    // MARK: - Outlets

    private let contentStackView = UIStackView()
    private let playersStackView = UIStackView()
    private let boardStackView = UIStackView()
    private let statusView = GameStatusView()

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

    func updatePlayers(_ players: [PlayerCardViewModel]) {
        for player in players {
            playerCards[player.side]?.configure(with: player)
        }
    }

    func updateStatus(_ status: GameStatusViewModel) {
        statusView.configure(with: status)
    }

    func reset() {
        for cell in cells.values {
            cell.clear()
        }
    }

    // MARK: - Setups

    private func setupView() {
        backgroundColor = .screenBackground
        setupPlayers()
        setupBoard()

        contentStackView.axis = .vertical
        contentStackView.spacing = Spacing.betweenBlocks(for: .regular)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.addArrangedSubview(playersStackView)
        contentStackView.addArrangedSubview(boardStackView)
        contentStackView.addArrangedSubview(statusView)
        addSubview(contentStackView)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Spacing.screenMargin
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: -Spacing.screenMargin
            ),
            contentStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            boardStackView.heightAnchor.constraint(equalTo: boardStackView.widthAnchor)
        ])
    }

    private func setupPlayers() {
        playersStackView.axis = .horizontal
        playersStackView.spacing = Spacing.betweenCards
        playersStackView.distribution = .fillEqually

        for side in Side.allCases {
            let playerCard = PlayerCardView()
            let heightConstraint = playerCard.heightAnchor.constraint(
                equalToConstant: Size.playerCardHeight(for: .regular)
            )
            heightConstraint.isActive = true
            playerCardHeightConstraints.append(heightConstraint)
            playerCards[side] = playerCard
            playersStackView.addArrangedSubview(playerCard)
        }
    }

    private func setupBoard() {
        boardStackView.axis = .vertical
        boardStackView.spacing = Spacing.betweenCells

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

            boardStackView.addArrangedSubview(cellRowStackView)
        }
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
        contentStackView.spacing = Spacing.betweenBlocks(for: newHeightClass)
        for constraint in playerCardHeightConstraints {
            constraint.constant = Size.playerCardHeight(for: newHeightClass)
        }
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
