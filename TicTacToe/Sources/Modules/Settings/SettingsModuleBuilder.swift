//
//  SettingsModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

struct SettingsModuleBuilder {
    static func build() -> UIViewController {
        let presenter = SettingsPresenter()
        let viewController = SettingsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
