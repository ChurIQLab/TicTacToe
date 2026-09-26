//
//  SceneDelegate.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var router: AppRouter?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = NavigationController()
        let router = AppRouter(navigationController: navigationController, settings: SettingsService())
        router.start()
        self.router = router
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
