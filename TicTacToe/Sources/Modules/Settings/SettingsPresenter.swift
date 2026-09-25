//
//  SettingsPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation

/// Only the title for now: the theme and haptics settings come with the settings task
final class SettingsPresenter {

    // MARK: - Properties

    weak var view: SettingsViewProtocol?
}

// MARK: - SettingsPresenterProtocol

extension SettingsPresenter: SettingsPresenterProtocol {
    func viewDidLoad() {
        view?.setTitle(String(localized: .settingsTitle))
    }
}
