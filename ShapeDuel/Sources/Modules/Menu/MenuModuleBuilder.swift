//
//  MenuModuleBuilder.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import UIKit

struct MenuModuleBuilder {
    static func build(router: MenuRouting) -> UIViewController {
        let presenter = MenuPresenter(router: router)
        let viewController = MenuViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
