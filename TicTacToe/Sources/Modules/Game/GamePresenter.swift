//
//  GamePresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

final class GamePresenter {

    // MARK: - Properties

    weak var view: GameViewProtocol?
    private let configuration: GameConfiguration
    private let router: GameRouting
    private let haptics: HapticsServiceProtocol
    private var engine = GameEngine()
    /// Alternates after every finished game; a restarted game keeps its first side
    private var firstSide: Side = .first
    private var scores: [Side: Int] = [:]

    // MARK: - Initial

    init(configuration: GameConfiguration, router: GameRouting, haptics: HapticsServiceProtocol) {
        self.configuration = configuration
        self.router = router
        self.haptics = haptics
    }

    // MARK: - Private methods

    private func startNewGame() {
        engine = GameEngine(firstSide: firstSide)
        view?.resetBoard()
        updatePanels()
    }

    private func finishGame(with result: GameResult) {
        switch result {
        case .win(let side, _):
            scores[side, default: 0] += 1
            haptics.playWin()
        case .draw:
            haptics.playDraw()
        }
        firstSide = firstSide.opponent
    }

    private func updatePanels() {
        updatePlayers()
        updateStatus()
    }

    private func updatePlayers() {
        let players = Side.allCases.map { side in
            PlayerCardViewModel(
                side: side,
                figure: figure(for: side),
                name: name(for: side),
                score: scores[side, default: 0],
                state: cardState(for: side)
            )
        }
        view?.updatePlayers(players)
    }

    private func updateStatus() {
        let status = switch engine.result {
        case .draw:
            GameStatusViewModel(text: String(localized: .drawMessage), player: nil)
        case .win(let winner, _):
            status(naming: winner) { String(localized: .winStatus($0)) }
        case nil:
            status(naming: engine.currentSide) { String(localized: .turnStatus($0)) }
        }
        view?.updateStatus(status)
    }

    private func status(naming side: Side, phrase: (String) -> String) -> GameStatusViewModel {
        GameStatusViewModel(side: side, figure: figure(for: side), name: name(for: side), phrase: phrase)
    }

    private func cardState(for side: Side) -> PlayerCardViewModel.State {
        switch engine.result {
        case .draw: .neutral
        case .win(let winner, _): winner == side ? .active : .inactive
        case nil: engine.currentSide == side ? .active : .inactive
        }
    }

    private func figure(for side: Side) -> Figure {
        configuration.figures[side] ?? Figure.defaultFigure(for: side)
    }

    private func name(for side: Side) -> String {
        configuration.names[side] ?? side.defaultPlayerName
    }

    private func winningLine(for result: GameResult) -> WinningLineViewModel? {
        guard
            case .win(let side, let line) = result,
            let start = line.first,
            let end = line.last
        else { return nil }
        return WinningLineViewModel(side: side, start: start, end: end)
    }

    private func resultViewModel(for result: GameResult) -> GameResultViewModel {
        let score = String(localized: .scoreSubtitle(scores[.first, default: 0], scores[.second, default: 0]))
        switch result {
        case .win(let side, _):
            return GameResultViewModel(
                title: String(localized: .winnerTitle(name(for: side))),
                score: score,
                figures: [SideFigure(side: side, figure: figure(for: side))],
                winner: side
            )
        case .draw:
            return GameResultViewModel(
                title: String(localized: .drawMessage),
                score: score,
                figures: Side.allCases.map { SideFigure(side: $0, figure: figure(for: $0)) },
                winner: nil
            )
        }
    }
}

// MARK: - GamePresenterProtocol

extension GamePresenter: GamePresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(configuration.mode.title)
        startNewGame()
    }

    func didTapCell(at position: Position) {
        let side = engine.currentSide

        do {
            try engine.play(at: position)
        } catch {
            return
        }

        view?.showFigure(figure(for: side), for: side, at: position)

        guard let result = engine.result else {
            haptics.playMove()
            updatePanels()
            return
        }
        finishGame(with: result)
        updatePanels()
        view?.showGameOver(resultViewModel(for: result), winningLine: winningLine(for: result))
    }

    func didTapNewGame() {
        startNewGame()
    }

    func didTapMenu() {
        router.showMenu()
    }
}
