//
//  GameSetupPresenterTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct GameSetupPresenterTests {

    @Test(arguments: [
        (GameMode.computer, String(localized: .computerTitle)),
        (GameMode.twoPlayers, String(localized: .twoPlayersTitle))
    ])
    func viewDidLoadSetsModeTitle(mode: GameMode, title: String) {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: mode, router: RouterSpy())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.titles == [title])
    }

    @Test(arguments: GameMode.allCases)
    func tapOnPlayShowsGameOfMode(mode: GameMode) {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: mode, router: router)

        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: mode))])
    }
}

// MARK: - GameSetupViewSpy

private final class GameSetupViewSpy: GameSetupViewProtocol {

    // MARK: - Properties

    private(set) var titles: [String] = []

    // MARK: - GameSetupViewProtocol

    func setTitle(_ title: String) {
        titles.append(title)
    }
}
