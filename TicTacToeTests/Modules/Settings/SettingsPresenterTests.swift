//
//  SettingsPresenterTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct SettingsPresenterTests {

    @Test func viewDidLoadSetsTitle() {
        let view = SettingsViewSpy()
        let presenter = SettingsPresenter()
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.titles == [String(localized: .settingsTitle)])
    }
}

// MARK: - SettingsViewSpy

private final class SettingsViewSpy: SettingsViewProtocol {

    // MARK: - Properties

    private(set) var titles: [String] = []

    // MARK: - SettingsViewProtocol

    func setTitle(_ title: String) {
        titles.append(title)
    }
}
