//
//  GamePresenterTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 12.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct GamePresenterTests {

    @Test func viewDidLoadResetsBoard() {
        let view = GameViewSpy()
        let presenter = GamePresenter()
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.events == [.resetBoard])
    }

    @Test func tapsShowSymbolsOfAlternatingSides() throws {
        let (presenter, view) = makePresenter()
        let firstCell = try position(0, 0)
        let secondCell = try position(1, 1)

        presenter.didTapCell(at: firstCell)
        presenter.didTapCell(at: secondCell)

        #expect(view.events == [.resetBoard, .showSymbol("X", firstCell), .showSymbol("O", secondCell)])
    }

    @Test func tapOnOccupiedCellIsIgnored() throws {
        let (presenter, view) = makePresenter()
        let cell = try position(1, 1)

        presenter.didTapCell(at: cell)
        presenter.didTapCell(at: cell)

        #expect(view.events == [.resetBoard, .showSymbol("X", cell)])
    }

    @Test func firstPlayerWinShowsWinnerMessage() throws {
        let (presenter, view) = makePresenter()
        let expectedMessage = String(localized: .winnerMessage(String(localized: .firstPlayerName)))

        try tap([(0, 0), (1, 0), (0, 1), (1, 1), (0, 2)], on: presenter)

        #expect(view.events.last == .showGameOver(expectedMessage))
    }

    @Test func secondPlayerWinShowsWinnerMessage() throws {
        let (presenter, view) = makePresenter()
        let expectedMessage = String(localized: .winnerMessage(String(localized: .secondPlayerName)))

        try tap([(1, 0), (0, 0), (1, 1), (0, 1), (2, 2), (0, 2)], on: presenter)

        #expect(view.events.last == .showGameOver(expectedMessage))
    }

    @Test func fullBoardWithoutLineShowsDraw() throws {
        let (presenter, view) = makePresenter()

        try tap([(0, 0), (0, 1), (0, 2), (1, 1), (1, 0), (1, 2), (2, 1), (2, 0), (2, 2)], on: presenter)

        #expect(view.events.last == .showGameOver(String(localized: .drawMessage)))
    }

    @Test func tapAfterGameOverIsIgnored() throws {
        let (presenter, view) = makePresenter()
        try tap([(0, 0), (1, 0), (0, 1), (1, 1), (0, 2)], on: presenter)
        let emptyCell = try position(2, 2)
        let eventsCount = view.events.count

        presenter.didTapCell(at: emptyCell)

        #expect(view.events.count == eventsCount)
    }

    @Test func newGameResetsBoardAndFirstSideMoves() throws {
        let (presenter, view) = makePresenter()
        let cell = try position(0, 0)
        presenter.didTapCell(at: cell)

        presenter.didTapNewGame()
        presenter.didTapCell(at: cell)

        #expect(Array(view.events.suffix(2)) == [.resetBoard, .showSymbol("X", cell)])
    }
}

extension GamePresenterTests {

    // MARK: - Private methods

    private func makePresenter() -> (GamePresenter, GameViewSpy) {
        let view = GameViewSpy()
        let presenter = GamePresenter()
        presenter.view = view
        presenter.viewDidLoad()
        return (presenter, view)
    }

    private func position(_ row: Int, _ column: Int) throws -> Position {
        try #require(Position(row: row, column: column))
    }

    private func tap(_ cells: [(Int, Int)], on presenter: GamePresenter) throws {
        for (row, column) in cells {
            let cell = try position(row, column)
            presenter.didTapCell(at: cell)
        }
    }
}
