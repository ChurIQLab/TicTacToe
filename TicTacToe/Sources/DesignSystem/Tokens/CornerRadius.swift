//
//  CornerRadius.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import CoreGraphics

/// Applied with the continuous corner curve
enum CornerRadius {

    // MARK: - Properties

    static let playerCard: CGFloat = 22
    static let menuItem: CGFloat = 24
    static let sheet: CGFloat = 34
    static let textField: CGFloat = 16
    static let figureTile: CGFloat = 20
    static let smallFigureTile: CGFloat = 12
    static let menuIcon: CGFloat = 26

    // MARK: - Methods

    static func cell(for heightClass: HeightClass) -> CGFloat {
        switch heightClass {
        case .regular: 26
        case .compact: 22
        }
    }
}
