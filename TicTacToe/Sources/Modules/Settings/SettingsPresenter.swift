//
//  SettingsPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// Every change is saved and applied at once, there is no confirmation button
final class SettingsPresenter {

    // MARK: - Properties

    weak var view: SettingsViewProtocol?

    private let settings: SettingsServiceProtocol
    private let appearance: AppearanceServiceProtocol

    // MARK: - Initial

    init(settings: SettingsServiceProtocol, appearance: AppearanceServiceProtocol) {
        self.settings = settings
        self.appearance = appearance
    }

    // MARK: - Private methods

    private func makeViewModel() -> SettingsViewModel {
        SettingsViewModel(
            appearanceLabel: String(localized: .appearanceSection),
            themePicker: ThemePickerViewModel(
                title: String(localized: .themeLabel),
                titles: Theme.allCases.map(\.title),
                selectedIndex: Theme.allCases.firstIndex(of: settings.theme) ?? 0
            )
        )
    }
}

// MARK: - SettingsPresenterProtocol

extension SettingsPresenter: SettingsPresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(String(localized: .settingsTitle))
        view?.showSettings(makeViewModel())
    }

    func didSelectTheme(at index: Int) {
        guard Theme.allCases.indices.contains(index) else { return }
        let theme = Theme.allCases[index]
        guard theme != settings.theme else { return }
        settings.theme = theme
        appearance.apply(theme, animated: true)
    }
}
