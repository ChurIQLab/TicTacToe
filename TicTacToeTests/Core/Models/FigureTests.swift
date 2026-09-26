//
//  FigureTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

import Testing
@testable import TicTacToe

struct FigureTests {

    @Test func thereAreEightFiguresInSpecificationOrder() {
        #expect(Figure.allCases == [.cross, .circle, .triangle, .square, .diamond, .star, .heart, .hexagon])
    }

    /// The raw values are stored in the settings
    @Test func rawValuesStayTheSame() {
        #expect(Figure.allCases.map(\.rawValue) == [
            "cross", "circle", "triangle", "square", "diamond", "star", "heart", "hexagon"
        ])
    }
}
