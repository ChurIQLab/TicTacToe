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

    @Test func twoPlayersSetupShowsNameFieldsWithDefaultNames() {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.nameFields == [[
            NameFieldViewModel(
                side: .first,
                label: String(localized: .firstPlayerName),
                placeholder: String(localized: .firstPlayerName),
                maxLength: GameConfiguration.maxNameLength
            ),
            NameFieldViewModel(
                side: .second,
                label: String(localized: .secondPlayerName),
                placeholder: String(localized: .secondPlayerName),
                maxLength: GameConfiguration.maxNameLength
            )
        ]])
        #expect(view.hints == [String(localized: .namesHint)])
    }

    @Test func computerSetupShowsNoNameFields() {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.nameFields.isEmpty)
    }

    @Test func tapOnPlayPassesEnteredNames() {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router)

        presenter.didChangeName("Ан", for: .first)
        presenter.didChangeName("Аня ", for: .first)
        presenter.didChangeName("Макс", for: .second)
        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(
            mode: .twoPlayers,
            names: [.first: "Аня", .second: "Макс"]
        ))])
    }

    @Test func clearedNameFallsBackToDefault() {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router)

        presenter.didChangeName("Аня", for: .first)
        presenter.didChangeName("", for: .first)
        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: .twoPlayers))])
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
    private(set) var nameFields: [[NameFieldViewModel]] = []
    private(set) var hints: [String] = []

    // MARK: - GameSetupViewProtocol

    func setTitle(_ title: String) {
        titles.append(title)
    }

    func showNameFields(_ fields: [NameFieldViewModel], hint: String) {
        nameFields.append(fields)
        hints.append(hint)
    }
}
