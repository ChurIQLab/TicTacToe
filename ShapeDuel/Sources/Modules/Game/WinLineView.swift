//
//  WinLineView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import UIKit

/// Overlays the board and strikes through the winning cells
final class WinLineView: UIView {

    // MARK: - Properties

    /// Space between the cells of the board underneath
    var spacing: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    private var winningLine: WinningLineViewModel?

    private var shapeLayer: CAShapeLayer {
        guard let shapeLayer = layer as? CAShapeLayer else {
            fatalError("WinLineView layer must be CAShapeLayer")
        }
        return shapeLayer
    }

    override static var layerClass: AnyClass {
        CAShapeLayer.self
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
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

    func show(_ winningLine: WinningLineViewModel, after delay: TimeInterval) {
        self.winningLine = winningLine
        updatePath()
        updateColor()

        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = Constants.drawDuration
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shapeLayer.add(animation, forKey: Constants.drawAnimationKey)
    }

    func hide() {
        winningLine = nil
        shapeLayer.removeAnimation(forKey: Constants.drawAnimationKey)
        updatePath()
    }

    // MARK: - Setups

    private func setupView() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        shapeLayer.fillColor = nil
        shapeLayer.lineCap = .round
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: WinLineView, _: UITraitCollection) in
            view.updateColor()
        }
    }

    // MARK: - Private methods

    private func updatePath() {
        guard let winningLine, !bounds.isEmpty else {
            shapeLayer.path = nil
            return
        }

        let side = bounds.width
        let direction = CGPoint(
            x: CGFloat((winningLine.end.column - winningLine.start.column).signum()),
            y: CGFloat((winningLine.end.row - winningLine.start.row).signum())
        )
        let overshoot = side * Constants.overshootRatio
        let start = center(of: winningLine.start)
        let end = center(of: winningLine.end)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: start.x - direction.x * overshoot, y: start.y - direction.y * overshoot))
        path.addLine(to: CGPoint(x: end.x + direction.x * overshoot, y: end.y + direction.y * overshoot))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = side * Constants.lineWidthRatio
    }

    private func center(of position: Position) -> CGPoint {
        let cellSide = (bounds.width - spacing * CGFloat(Board.size - 1)) / CGFloat(Board.size)
        let step = cellSide + spacing
        return CGPoint(
            x: CGFloat(position.column) * step + cellSide / 2,
            y: CGFloat(position.row) * step + cellSide / 2
        )
    }

    private func updateColor() {
        shapeLayer.strokeColor = winningLine?.side.color.resolvedColor(with: traitCollection).cgColor
    }
}

// MARK: - Constants

extension WinLineView {
    struct Constants {
        static let drawAnimationKey = "draw"
        static let drawDuration: TimeInterval = 0.35
        /// In the mockup the board is 300 wide, the line is 9 thick and goes 26 / 3 beyond the cell centers
        static let lineWidthRatio: CGFloat = 9 / 300
        static let overshootRatio: CGFloat = 26 / 3 / 300
    }
}
