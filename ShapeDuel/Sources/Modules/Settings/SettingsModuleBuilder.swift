//
//  SettingsModuleBuilder.swift
//  ShapeDuel
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
        let presenter = SettingsPresenter(
            settings: settings,
            appearance: appearance,
            haptics: haptics,
            appVersion: appVersion
        )
        let viewController = SettingsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }

    /// The marketing version from the project settings, such as 1.0
    private static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
