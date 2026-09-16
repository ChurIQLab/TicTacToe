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
            surfaceView.backgroundColor = .surface
            surfaceView.layer.cornerCurve = .continuous
            surfaceView.isUserInteractionEnabled = false
            addSubview(surfaceView)
        }
        updateShadows()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (cardView: CardView, _: UITraitCollection) in
            cardView.updateShadows()
        }
    }

    // MARK: - Private methods

    private func updateShadows() {
        for (surfaceView, shadow) in zip(surfaceViews, Shadow.card) {
            shadow.apply(to: surfaceView.layer, for: traitCollection)
        }
    }
}
