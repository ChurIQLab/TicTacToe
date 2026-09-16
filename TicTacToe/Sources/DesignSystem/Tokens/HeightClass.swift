//
//  HeightClass.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import CoreGraphics

nonisolated enum HeightClass: Sendable {
    case regular
    case compact

    // MARK: - Initial

    init(screenHeight: CGFloat) {
        self = screenHeight < Constants.compactScreenHeightLimit ? .compact : .regular
    }
}

// MARK: - Constants

extension HeightClass {
    nonisolated struct Constants {
        /// iPhone SE is 667 pt tall
        static let compactScreenHeightLimit: CGFloat = 700
    }
}
