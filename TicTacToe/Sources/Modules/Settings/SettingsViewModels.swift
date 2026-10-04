//
//  SettingsViewModels.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 04.10.2026.
//

nonisolated struct ThemePickerViewModel: Equatable, Sendable {
    let title: String
    let titles: [String]
    let selectedIndex: Int
}

nonisolated struct SwitchRowViewModel: Equatable, Sendable {
    let title: String
    let isOn: Bool
}

nonisolated struct SettingsViewModel: Equatable, Sendable {
    let appearanceLabel: String
    let themePicker: ThemePickerViewModel
    let gameLabel: String
    let hapticsSwitch: SwitchRowViewModel
}
