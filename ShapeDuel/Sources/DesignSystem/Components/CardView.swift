//
//  CardView.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import UIKit

final class CardView: UIView {

    // MARK: - Properties

    var cornerRadius: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }

    /// Replaces the surface and shadows with a tinted fill and an inner border
    var highlight: Highlight? {
        didSet {
            updateAppearance()
        }
    }

    /// One surface view per shadow layer: the upper surface covers the shadows of the lower ones
    private let surfaceViews = Shadow.card.map { _ in UIView() }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        for surfaceView in surfaceViews {
            surfaceView.frame = bounds
            surfaceView.layer.cornerRadius = cornerRadius
            surfaceView.layer.shadowPath = shadowPath
        }
    }

    // MARK: - Initial

    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    private func setupView() {
        for surfaceView in surfaceViews {
            surfaceView.layer.cornerCurve = .continuous
            surfaceView.isUserInteractionEnabled = false
            addSubview(surfaceView)
        }
        updateAppearance()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (cardView: CardView, _: UITraitCollection) in
            cardView.updateAppearance()
        }
    }

    // MARK: - Private methods

    private func updateAppearance() {
        for (surfaceView, shadow) in zip(surfaceViews, Shadow.card) {
            surfaceView.backgroundColor = highlight?.fillColor ?? .surface
            shadow.apply(to: surfaceView.layer, for: traitCollection)
            if highlight != nil {
                surfaceView.layer.shadowOpacity = 0
            }
        }

        guard let topLayer = surfaceViews.last?.layer else { return }
        topLayer.borderWidth = highlight == nil ? 0 : Constants.highlightBorderWidth
        topLayer.borderColor = highlight?.borderColor.resolvedColor(with: traitCollection).cgColor
    }
}

// MARK: - Highlight

extension CardView {
    struct Highlight {
        let fillColor: UIColor
        let borderColor: UIColor
    }
}

// MARK: - Constants

extension CardView {
    struct Constants {
        static let highlightBorderWidth: CGFloat = 2
    }
}
