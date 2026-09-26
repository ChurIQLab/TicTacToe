//
//  GameSetupModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

struct GameSetupModuleBuilder {
    static func build(mode: GameMode, router: GameSetupRouting, settings: SettingsServiceProtocol) -> UIViewController {
        let presenter = GameSetupPresenter(mode: mode, router: router, settings: settings)
        let viewController = GameSetupViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
