//
//  Shadow.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import UIKit

struct Shadow {

    // MARK: - Properties

    static let card: [Shadow] = [
        Shadow(offsetY: 1, blur: 2, opacity: 0.05),
        Shadow(offsetY: 6, blur: 16, opacity: 0.05)
    ]

    static let menuIcon: [Shadow] = [
        Shadow(offsetY: 2, blur: 4, opacity: 0.06),
        Shadow(offsetY: 12, blur: 28, opacity: 0.12)
    ]

    let offsetY: CGFloat
    let blur: CGFloat
    let opacity: Float

    // MARK: - Methods

    /// In the dark theme there are no shadows: objects stand out by the surface color
    func apply(to layer: CALayer, for traitCollection: UITraitCollection) {
        layer.shadowColor = Constants.color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: offsetY)
        // CSS blur is twice the Core Animation shadow radius
        layer.shadowRadius = blur / 2
        layer.shadowOpacity = traitCollection.userInterfaceStyle == .dark ? 0 : opacity
    }
}

// MARK: - Constants

extension Shadow {
    struct Constants {
        static let color = UIColor(red: 26 / 255, green: 26 / 255, blue: 46 / 255, alpha: 1)
    }
}
