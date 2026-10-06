//
//  Figure+Name.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

import Foundation

extension Figure {
    var accessibilityName: String {
        switch self {
        case .cross: String(localized: .crossFigure)
        case .circle: String(localized: .circleFigure)
        case .triangle: String(localized: .triangleFigure)
        case .square: String(localized: .squareFigure)
        case .diamond: String(localized: .diamondFigure)
        case .star: String(localized: .starFigure)
        case .heart: String(localized: .heartFigure)
        case .hexagon: String(localized: .hexagonFigure)
        }
    }
}
