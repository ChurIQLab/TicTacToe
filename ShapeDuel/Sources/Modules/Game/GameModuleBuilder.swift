//
//  GameModuleBuilder.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

struct GameModuleBuilder {
    static func build(
        configuration: GameConfiguration,
        router: GameRouting,
        haptics: HapticsServiceProtocol
    ) -> UIViewController {
        let presenter = GamePresenter(
            configuration: configuration,
            router: router,
            haptics: haptics,
            scheduler: ComputerMoveScheduler()
        )
        let viewController = GameViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
