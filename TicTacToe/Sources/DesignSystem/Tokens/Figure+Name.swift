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
        }
    }
}
