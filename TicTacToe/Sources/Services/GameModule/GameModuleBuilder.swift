//
//  GameModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

struct GameModuleBuilder {
    static func build() -> UIViewController {
        let gameView = GameView()
        let presenter = GamePresenter(view: gameView)
        let viewController = GameViewController(presenter: presenter, gameView: gameView)
        return viewController
    }
}
