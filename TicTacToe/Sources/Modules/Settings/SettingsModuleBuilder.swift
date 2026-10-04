//
//  SettingsModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

struct SettingsModuleBuilder {
    static func build(
        settings: SettingsServiceProtocol,
        appearance: AppearanceServiceProtocol,
        haptics: HapticsServiceProtocol
    ) -> UIViewController {
        let presenter = SettingsPresenter(settings: settings, appearance: appearance, haptics: haptics)
        let viewController = SettingsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
