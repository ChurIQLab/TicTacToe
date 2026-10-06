//
//  Figure.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 23.09.2026.
//

/// Raw values are stored in the settings, so they must not change
nonisolated enum Figure: String, CaseIterable, Sendable {
    case cross
    case circle
    case triangle
    case square
    case diamond
    case star
    case heart
    case hexagon
}

nonisolated extension Figure {

    // MARK: - Methods

    static func defaultFigure(for side: Side) -> Figure {
        switch side {
        case .first: .cross
        case .second: .circle
        }
    }

    /// Gives a side without a figure its default one; if the sides end up with the same figure,
    /// the second side gets the first free one. Against the computer this picks its figure:
    /// the circle, or the cross when the player took the circle
    static func distinctFigures(_ figures: [Side: Figure]) -> [Side: Figure] {
        let first = figures[.first] ?? defaultFigure(for: .first)
        var second = figures[.second] ?? defaultFigure(for: .second)
        if second == first {
            second = allCases.first { $0 != first } ?? second
        }
        return [.first: first, .second: second]
    }
}
