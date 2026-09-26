//
//  FigureAppearanceTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
import UIKit
@testable import TicTacToe

struct FigureAppearanceTests {

    @Test(arguments: Figure.allCases)
    func outlineWithStrokeFitsTheGrid(figure: Figure) {
        let bounds = figure.path.bounds
        let grid = CGRect(x: 0, y: 0, width: Figure.gridSize, height: Figure.gridSize)
            .insetBy(dx: Figure.lineWidth / 2, dy: Figure.lineWidth / 2)

        #expect(!bounds.isEmpty)
        #expect(grid.contains(bounds))
    }

    @Test func accessibilityNamesAreDifferent() {
        let names = Figure.allCases.map(\.accessibilityName)

        #expect(names.allSatisfy { !$0.isEmpty })
        #expect(Set(names).count == Figure.allCases.count)
    }
}
