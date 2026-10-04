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

    // MARK: - Properties

    private let view = SettingsViewSpy()
    private let settings = SettingsServiceFake()
    private let appearance = AppearanceServiceSpy()
    private let haptics = HapticsServiceSpy()

    // MARK: - Tests

    @Test func viewDidLoadSetsTitle() {
        let presenter = makePresenter()

        presenter.viewDidLoad()

        #expect(view.titles == [String(localized: .settingsTitle)])
    }

    @Test func viewDidLoadShowsThemesInOrder() throws {
        let presenter = makePresenter()

        presenter.viewDidLoad()

        let shown = try #require(view.shownSettings.last)
        #expect(shown.appearanceLabel == String(localized: .appearanceSection))
        #expect(shown.themePicker.title == String(localized: .themeLabel))
        #expect(shown.themePicker.titles == [
            String(localized: .systemTheme),
            String(localized: .lightTheme),
            String(localized: .darkTheme)
        ])
    }

    @Test(arguments: Theme.allCases)
    func savedThemeIsSelected(_ theme: Theme) throws {
        settings.theme = theme
        let presenter = makePresenter()

        presenter.viewDidLoad()

        let shown = try #require(view.shownSettings.last)
        #expect(shown.themePicker.selectedIndex == Theme.allCases.firstIndex(of: theme))
    }

    @Test func viewDidLoadDoesNotApplyTheme() {
        let presenter = makePresenter()

        presenter.viewDidLoad()

        #expect(appearance.appliedThemes.isEmpty)
    }

    @Test func selectedThemeIsSavedAndAppliedWithAnimation() throws {
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didSelectTheme(at: try #require(Theme.allCases.firstIndex(of: .dark)))

        #expect(settings.theme == .dark)
        #expect(appearance.appliedThemes == [.init(theme: .dark, animated: true)])
    }

    @Test func selectingCurrentThemeDoesNothing() throws {
        settings.theme = .light
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didSelectTheme(at: try #require(Theme.allCases.firstIndex(of: .light)))

        #expect(appearance.appliedThemes.isEmpty)
    }

    @Test(arguments: [-1, 3])
    func themeIndexOutOfRangeIsIgnored(index: Int) {
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didSelectTheme(at: index)

        #expect(settings.theme == .system)
        #expect(appearance.appliedThemes.isEmpty)
    }

    @Test(arguments: [true, false])
    func viewDidLoadShowsSavedHaptics(isOn: Bool) throws {
        settings.isHapticsEnabled = isOn
        let presenter = makePresenter()

        presenter.viewDidLoad()

        let shown = try #require(view.shownSettings.last)
        #expect(shown.gameLabel == String(localized: .gameSection))
        #expect(shown.hapticsSwitch == SwitchRowViewModel(title: String(localized: .hapticsLabel), isOn: isOn))
    }

    @Test func turningHapticsOffSavesWithoutTap() {
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didChangeHaptics(isOn: false)

        #expect(!settings.isHapticsEnabled)
        #expect(haptics.events.isEmpty)
    }

    @Test func turningHapticsOnSavesAndTapsOnce() {
        settings.isHapticsEnabled = false
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didChangeHaptics(isOn: true)

        #expect(settings.isHapticsEnabled)
        #expect(haptics.events == [.move])
    }

    @Test func unchangedHapticsDoNothing() {
        let presenter = makePresenter()
        presenter.viewDidLoad()

        presenter.didChangeHaptics(isOn: true)

        #expect(haptics.events.isEmpty)
    }
}

extension SettingsPresenterTests {

    // MARK: - Private methods

    private func makePresenter() -> SettingsPresenter {
        let presenter = SettingsPresenter(settings: settings, appearance: appearance, haptics: haptics)
        presenter.view = view
        return presenter
    }
}

// MARK: - SettingsViewSpy

private final class SettingsViewSpy: SettingsViewProtocol {

    // MARK: - Properties

    private(set) var titles: [String] = []
    private(set) var shownSettings: [SettingsViewModel] = []

    // MARK: - SettingsViewProtocol

    func setTitle(_ title: String) {
        titles.append(title)
    }

    func showSettings(_ settings: SettingsViewModel) {
        shownSettings.append(settings)
    }
}
