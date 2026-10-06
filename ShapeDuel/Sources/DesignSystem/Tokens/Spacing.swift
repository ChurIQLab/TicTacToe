//
//  Spacing.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import CoreGraphics

enum Spacing {

    // MARK: - Properties

    static let screenMargin: CGFloat = 20
    static let betweenCards: CGFloat = 12
    static let betweenCells: CGFloat = 10
    static let cardPadding: CGFloat = 16
    static let menuItemPadding: CGFloat = 18

    // MARK: - Methods

    static func betweenBlocks(for heightClass: HeightClass) -> CGFloat {
        switch heightClass {
        case .regular: 28
        case .compact: 18
        }
    }
}
