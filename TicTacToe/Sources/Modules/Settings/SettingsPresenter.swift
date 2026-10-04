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
    private let haptics: HapticsServiceProtocol

    // MARK: - Initial

    init(
        settings: SettingsServiceProtocol,
        appearance: AppearanceServiceProtocol,
        haptics: HapticsServiceProtocol
    ) {
        self.settings = settings
        self.appearance = appearance
        self.haptics = haptics
    }

    // MARK: - Private methods

    private func makeViewModel() -> SettingsViewModel {
        SettingsViewModel(
            appearanceLabel: String(localized: .appearanceSection),
            themePicker: ThemePickerViewModel(
                title: String(localized: .themeLabel),
                titles: Theme.allCases.map(\.title),
                selectedIndex: Theme.allCases.firstIndex(of: settings.theme) ?? 0
            ),
            gameLabel: String(localized: .gameSection),
            hapticsSwitch: SwitchRowViewModel(
                title: String(localized: .hapticsLabel),
                isOn: settings.isHapticsEnabled
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

    /// Turning haptics on taps once, so the player feels what they enabled
    func didChangeHaptics(isOn: Bool) {
        guard isOn != settings.isHapticsEnabled else { return }
        settings.isHapticsEnabled = isOn
        if isOn {
            haptics.playMove()
        }
    }
}
