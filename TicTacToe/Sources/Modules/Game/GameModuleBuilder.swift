//
//  GameModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

struct GameModuleBuilder {
    static func build(mode: GameMode) -> UIViewController {
        let presenter = GamePresenter(mode: mode, haptics: HapticsService())
        let viewController = GameViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
