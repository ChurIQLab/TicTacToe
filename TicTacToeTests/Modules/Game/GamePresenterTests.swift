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

    @Test func viewDidLoadSetsTitleAndResetsBoard() {
        let view = GameViewSpy()
        let presenter = GamePresenter(haptics: HapticsServiceSpy())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(Array(view.events.prefix(2)) == [.setTitle(String(localized: .twoPlayersTitle)), .resetBoard])
    }

    @Test func tapsShowFiguresOfAlternatingSides() throws {
        let (presenter, view) = makePresenter()
        let firstCell = try position(0, 0)
        let secondCell = try position(1, 1)

        presenter.didTapCell(at: firstCell)
        presenter.didTapCell(at: secondCell)

        #expect(view.boardEvents == [
            .resetBoard,
            .showFigure(.cross, .first, firstCell),
            .showFigure(.circle, .second, secondCell)
        ])
    }

    @Test func tapOnOccupiedCellIsIgnored() throws {
        let (presenter, view) = makePresenter()
        let cell = try position(1, 1)

        presenter.didTapCell(at: cell)
        presenter.didTapCell(at: cell)

        #expect(view.boardEvents == [.resetBoard, .showFigure(.cross, .first, cell)])
    }

    @Test func firstPlayerWinShowsResultAndLine() throws {
        let (presenter, view) = makePresenter()
        let expectedResult = GameResultViewModel(
            title: String(localized: .winnerTitle(String(localized: .firstPlayerName))),
            score: String(localized: .scoreSubtitle(1, 0)),
            figures: [SideFigure(side: .first, figure: .cross)],
            winner: .first
        )

        try tap(firstSideWin, on: presenter)

        #expect(view.events.last == .showGameOver(
            expectedResult,
            WinningLineViewModel(side: .first, start: try position(0, 0), end: try position(0, 2))
        ))
    }

    @Test func secondPlayerWinShowsResultAndLine() throws {
        let (presenter, view) = makePresenter()
        let expectedResult = GameResultViewModel(
            title: String(localized: .winnerTitle(String(localized: .secondPlayerName))),
            score: String(localized: .scoreSubtitle(0, 1)),
            figures: [SideFigure(side: .second, figure: .circle)],
            winner: .second
        )

        try tap([(1, 0), (0, 0), (1, 1), (0, 1), (2, 2), (0, 2)], on: presenter)

        #expect(view.events.last == .showGameOver(
            expectedResult,
            WinningLineViewModel(side: .second, start: try position(0, 0), end: try position(0, 2))
        ))
    }

    @Test func fullBoardShowsDrawWithBothFiguresAndNoLine() throws {
        let (presenter, view) = makePresenter()
        let expectedResult = GameResultViewModel(
            title: String(localized: .drawMessage),
            score: String(localized: .scoreSubtitle(0, 0)),
            figures: [SideFigure(side: .first, figure: .cross), SideFigure(side: .second, figure: .circle)],
            winner: nil
        )

        try tap(draw, on: presenter)

        #expect(view.events.last == .showGameOver(expectedResult, nil))
    }

    @Test func tapAfterGameOverIsIgnored() throws {
        let (presenter, view) = makePresenter()
        try tap(firstSideWin, on: presenter)
        let emptyCell = try position(2, 2)
        let eventsCount = view.events.count

        presenter.didTapCell(at: emptyCell)

        #expect(view.events.count == eventsCount)
    }

    @Test func playersStartWithZeroScoreAndFirstSideActive() {
        let (_, view) = makePresenter()

        #expect(view.players == [
            PlayerCardViewModel(
                side: .first,
                figure: .cross,
                name: String(localized: .firstPlayerName),
                score: 0,
                state: .active
            ),
            PlayerCardViewModel(
                side: .second,
                figure: .circle,
                name: String(localized: .secondPlayerName),
                score: 0,
                state: .inactive
            )
        ])
    }

    @Test func activePlayerFollowsTurn() throws {
        let (presenter, view) = makePresenter()

        presenter.didTapCell(at: try position(0, 0))

        #expect(view.players.map(\.state) == [.inactive, .active])
    }

    @Test func winAddsPointToWinnerAndKeepsWinnerActive() throws {
        let (presenter, view) = makePresenter()

        try tap(firstSideWin, on: presenter)

        #expect(view.players.map(\.score) == [1, 0])
        #expect(view.players.map(\.state) == [.active, .inactive])
    }

    @Test func drawKeepsScoresAndHighlightsNobody() throws {
        let (presenter, view) = makePresenter()

        try tap(draw, on: presenter)

        #expect(view.players.map(\.score) == [0, 0])
        #expect(view.players.map(\.state) == [.neutral, .neutral])
    }

    @Test func statusShowsWhoseTurnItIs() throws {
        let (presenter, view) = makePresenter()
        let secondName = String(localized: .secondPlayerName)

        presenter.didTapCell(at: try position(0, 0))

        #expect(view.status == GameStatusViewModel(
            text: String(localized: .turnStatus(secondName)),
            player: GameStatusViewModel.Player(side: .second, figure: .circle, name: secondName)
        ))
    }

    @Test func statusShowsWinner() throws {
        let (presenter, view) = makePresenter()
        let firstName = String(localized: .firstPlayerName)

        try tap(firstSideWin, on: presenter)

        #expect(view.status == GameStatusViewModel(
            text: String(localized: .winStatus(firstName)),
            player: GameStatusViewModel.Player(side: .first, figure: .cross, name: firstName)
        ))
    }

    @Test func statusShowsDraw() throws {
        let (presenter, view) = makePresenter()

        try tap(draw, on: presenter)

        #expect(view.status == GameStatusViewModel(text: String(localized: .drawMessage), player: nil))
    }

    @Test func moveAndWinPlayHaptics() throws {
        let haptics = HapticsServiceSpy()
        let (presenter, _) = makePresenter(haptics: haptics)

        try tap(firstSideWin, on: presenter)

        #expect(haptics.events == [.move, .move, .move, .move, .win])
    }

    @Test func drawPlaysDrawHaptic() throws {
        let haptics = HapticsServiceSpy()
        let (presenter, _) = makePresenter(haptics: haptics)

        try tap(draw, on: presenter)

        #expect(haptics.events.last == .draw)
    }

    @Test func ignoredTapPlaysNoHaptic() throws {
        let haptics = HapticsServiceSpy()
        let (presenter, _) = makePresenter(haptics: haptics)
        let cell = try position(1, 1)

        presenter.didTapCell(at: cell)
        presenter.didTapCell(at: cell)

        #expect(haptics.events == [.move])
    }

    @Test func newGameAfterFinishedGameAlternatesFirstSideAndKeepsScore() throws {
        let (presenter, view) = makePresenter()
        try tap(firstSideWin, on: presenter)
        let cell = try position(0, 0)

        presenter.didTapNewGame()
        presenter.didTapCell(at: cell)

        #expect(Array(view.boardEvents.suffix(2)) == [.resetBoard, .showFigure(.circle, .second, cell)])
        #expect(view.players.map(\.score) == [1, 0])
    }

    @Test func restartKeepsFirstSideAndScore() throws {
        let (presenter, view) = makePresenter()
        try tap(firstSideWin, on: presenter)
        presenter.didTapNewGame()
        presenter.didTapCell(at: try position(1, 1))
        let cell = try position(0, 0)

        presenter.didTapNewGame()
        presenter.didTapCell(at: cell)

        #expect(Array(view.boardEvents.suffix(2)) == [.resetBoard, .showFigure(.circle, .second, cell)])
        #expect(view.players.map(\.score) == [1, 0])
    }
}

extension GamePresenterTests {

    // MARK: - Properties

    /// The first side completes the top row
    private var firstSideWin: [(Int, Int)] {
        [(0, 0), (1, 0), (0, 1), (1, 1), (0, 2)]
    }

    private var draw: [(Int, Int)] {
        [(0, 0), (0, 1), (0, 2), (1, 1), (1, 0), (1, 2), (2, 1), (2, 0), (2, 2)]
    }

    // MARK: - Private methods

    private func makePresenter(haptics: HapticsServiceSpy = HapticsServiceSpy()) -> (GamePresenter, GameViewSpy) {
        let view = GameViewSpy()
        let presenter = GamePresenter(haptics: haptics)
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
