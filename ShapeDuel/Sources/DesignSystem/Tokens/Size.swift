//
//  Size.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import CoreGraphics

enum Size {

    // MARK: - Properties

    static let buttonHeight: CGFloat = 56
    static let sheetButtonHeight: CGFloat = 54
    static let menuItemHeight: CGFloat = 84
    static let textFieldHeight: CGFloat = 52
    static let segmentedControlHeight: CGFloat = 44
    static let segmentedControlHeightInCard: CGFloat = 40
    static let figureInCard: CGFloat = 24
    static let figureInStatus: CGFloat = 18
    /// In a tile of the 4-column grid and of the row of 8
    static let figureInTile: CGFloat = 36
    static let figureInSmallTile: CGFloat = 22
    static let menuIcon: CGFloat = 112

    // MARK: - Methods

    static func playerCardHeight(for heightClass: HeightClass) -> CGFloat {
        switch heightClass {
        case .regular: 76
        case .compact: 64
        }
    }

    static func figureInCell(for heightClass: HeightClass) -> CGFloat {
        switch heightClass {
        case .regular: 56
        case .compact: 50
        }
    }
}
