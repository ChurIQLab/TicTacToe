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
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // The saved theme is set before the window shows, so the first frame is already in it
        let settings = SettingsService()
        let appearance = AppearanceService(window: window)
        appearance.apply(settings.theme, animated: false)

        let navigationController = NavigationController()
        let router = AppRouter(navigationController: navigationController, settings: settings, appearance: appearance)
        router.start()
        self.router = router
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
