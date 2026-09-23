//
//  FigureView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import UIKit

final class FigureView: UIView {

    // MARK: - Properties

    private var figure: Figure?
    private var color: UIColor = .primaryText

    private var shapeLayer: CAShapeLayer {
        guard let shapeLayer = layer as? CAShapeLayer else {
            fatalError("FigureView layer must be CAShapeLayer")
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

    func show(_ figure: Figure?, color: UIColor, animated: Bool = false) {
        self.figure = figure
        self.color = color
        updatePath()
        updateColor()

        shapeLayer.removeAnimation(forKey: Constants.drawAnimationKey)
        guard animated, figure != nil else { return }
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Constants.drawDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        shapeLayer.add(animation, forKey: Constants.drawAnimationKey)
    }

    // MARK: - Setups

    private func setupView() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        shapeLayer.fillColor = nil
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (figureView: FigureView, _: UITraitCollection) in
            figureView.updateColor()
        }
    }

    // MARK: - Private methods

    private func updatePath() {
        guard let figure, !bounds.isEmpty else {
            shapeLayer.path = nil
            return
        }
        let scale = min(bounds.width, bounds.height) / Figure.gridSize
        let offset = CGPoint(
            x: (bounds.width - Figure.gridSize * scale) / 2,
            y: (bounds.height - Figure.gridSize * scale) / 2
        )
        let path = figure.path
        path.apply(CGAffineTransform(translationX: offset.x, y: offset.y).scaledBy(x: scale, y: scale))
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = Figure.lineWidth * scale
    }

    private func updateColor() {
        shapeLayer.strokeColor = color.resolvedColor(with: traitCollection).cgColor
    }
}

// MARK: - Constants

extension FigureView {
    struct Constants {
        static let drawAnimationKey = "draw"
        static let drawDuration: CFTimeInterval = 0.3
    }
}
