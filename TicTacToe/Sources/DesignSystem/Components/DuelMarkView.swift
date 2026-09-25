//
//  DuelMarkView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

/// The «Duel» mark from the app icon: a cross of the first side overlapped by a circle of the second side
final class DuelMarkView: UIView {

    // MARK: - Properties

    /// One tile per shadow layer: the upper tile covers the shadows of the lower ones
    private let tileViews = Shadow.menuIcon.map { _ in UIView() }
    private let crossLayer = CAShapeLayer()
    /// Covers the cross under the circle and around it with the tile color
    private let gapLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = bounds.width * Constants.cornerRadiusRatio
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        for tileView in tileViews {
            tileView.frame = bounds
            tileView.layer.cornerRadius = cornerRadius
            tileView.layer.shadowPath = shadowPath
        }
        updatePaths()
    }

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
        isUserInteractionEnabled = false
        for tileView in tileViews {
            tileView.layer.cornerCurve = .continuous
            addSubview(tileView)
        }
        for shapeLayer in [crossLayer, circleLayer] {
            shapeLayer.fillColor = nil
            shapeLayer.lineCap = .round
        }
        for shapeLayer in [crossLayer, gapLayer, circleLayer] {
            layer.addSublayer(shapeLayer)
        }
        updateColors()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (markView: DuelMarkView, _: UITraitCollection) in
            markView.updateColors()
        }
    }

    // MARK: - Private methods

    private func updatePaths() {
        let scale = bounds.width / Constants.gridSize
        let transform = CGAffineTransform(scaleX: scale, y: scale)

        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: Constants.crossStart, y: Constants.crossStart))
        crossPath.addLine(to: CGPoint(x: Constants.crossEnd, y: Constants.crossEnd))
        crossPath.move(to: CGPoint(x: Constants.crossEnd, y: Constants.crossStart))
        crossPath.addLine(to: CGPoint(x: Constants.crossStart, y: Constants.crossEnd))
        crossPath.apply(transform)

        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: Constants.circleCenter, y: Constants.circleCenter),
            radius: Constants.circleRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        circlePath.apply(transform)

        let gapRadius = Constants.circleRadius + Constants.gapWidth / 2
        let gapPath = UIBezierPath(
            ovalIn: CGRect(
                x: Constants.circleCenter - gapRadius,
                y: Constants.circleCenter - gapRadius,
                width: gapRadius * 2,
                height: gapRadius * 2
            )
        )
        gapPath.apply(transform)

        crossLayer.path = crossPath.cgPath
        gapLayer.path = gapPath.cgPath
        circleLayer.path = circlePath.cgPath
        crossLayer.lineWidth = Constants.lineWidth * scale
        circleLayer.lineWidth = Constants.lineWidth * scale
    }

    private func updateColors() {
        let tileColor = UIColor.iconBackground.resolvedColor(with: traitCollection)
        for (tileView, shadow) in zip(tileViews, Shadow.menuIcon) {
            tileView.backgroundColor = tileColor
            shadow.apply(to: tileView.layer, for: traitCollection)
        }
        // In the dark theme a thin light border separates the mark from the background instead of the shadow
        if let topLayer = tileViews.last?.layer {
            let isDark = traitCollection.userInterfaceStyle == .dark
            topLayer.borderWidth = isDark ? Constants.darkBorderWidth : 0
            topLayer.borderColor = Constants.darkBorderColor.cgColor
        }
        crossLayer.strokeColor = UIColor.firstSide.resolvedColor(with: traitCollection).cgColor
        gapLayer.fillColor = tileColor.cgColor
        circleLayer.strokeColor = UIColor.secondSide.resolvedColor(with: traitCollection).cgColor
    }
}

// MARK: - Constants

extension DuelMarkView {
    /// Geometry in the 100×100 grid of the icon concept
    struct Constants {
        static let gridSize: CGFloat = 100
        static let cornerRadiusRatio = CornerRadius.menuIcon / Size.menuIcon
        static let crossStart: CGFloat = 21
        static let crossEnd: CGFloat = 53
        static let circleCenter: CGFloat = 60
        static let circleRadius: CGFloat = 19
        static let lineWidth: CGFloat = 11
        static let gapWidth: CGFloat = 20
        static let darkBorderWidth: CGFloat = 1
        static let darkBorderColor = UIColor.white.withAlphaComponent(0.08)
    }
}
