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

    @Test func defaultFiguresAreCrossAndCircle() {
        #expect(Figure.distinctFigures([:]) == [.first: .cross, .second: .circle])
    }

    @Test func differentFiguresAreKept() {
        #expect(Figure.distinctFigures([.first: .star, .second: .heart]) == [.first: .star, .second: .heart])
    }

    @Test func missingSideGetsItsDefaultFigure() {
        #expect(Figure.distinctFigures([.first: .star]) == [.first: .star, .second: .circle])
        #expect(Figure.distinctFigures([.second: .star]) == [.first: .cross, .second: .star])
    }

    @Test(arguments: [
        (Figure.star, Figure.cross),
        (Figure.cross, Figure.circle)
    ])
    func sameFiguresGiveSecondSideFirstFreeFigure(figure: Figure, expectedSecond: Figure) {
        #expect(Figure.distinctFigures([.first: figure, .second: figure]) == [.first: figure, .second: expectedSecond])
    }

    /// Against the computer only the player's figure is known
    @Test func playerWithCircleLeavesCrossToSecondSide() {
        #expect(Figure.distinctFigures([.first: .circle]) == [.first: .circle, .second: .cross])
    }
}
