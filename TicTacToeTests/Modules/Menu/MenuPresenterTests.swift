//
//  MenuPresenterTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct MenuPresenterTests {

    @Test func viewDidLoadShowsBothModes() {
        let (presenter, view) = makePresenter()

        presenter.viewDidLoad()

        #expect(view.items == [[
            MenuItemViewModel(
                mode: .computer,
                title: String(localized: .computerTitle),
                subtitle: String(localized: .computerSubtitle)
            ),
            MenuItemViewModel(
                mode: .twoPlayers,
                title: String(localized: .twoPlayersTitle),
                subtitle: String(localized: .twoPlayersSubtitle)
            )
        ]])
    }

    @Test(arguments: GameMode.allCases)
    func selectingModeShowsGameSetup(mode: GameMode) {
        let router = RouterSpy()
        let (presenter, _) = makePresenter(router: router)

        presenter.didSelectMode(mode)

        #expect(router.events == [.showGameSetup(mode)])
    }

    @Test func tapOnSettingsShowsSettings() {
        let router = RouterSpy()
        let (presenter, _) = makePresenter(router: router)

        presenter.didTapSettings()

        #expect(router.events == [.showSettings])
    }
}

extension MenuPresenterTests {

    // MARK: - Private methods

    private func makePresenter(router: RouterSpy = RouterSpy()) -> (MenuPresenter, MenuViewSpy) {
        let view = MenuViewSpy()
        let presenter = MenuPresenter(router: router)
        presenter.view = view
        return (presenter, view)
    }
}
