//
//  Side+Color.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import UIKit

extension Side {
    var color: UIColor {
        switch self {
        case .first: .firstSide
        case .second: .secondSide
        }
    }
}
