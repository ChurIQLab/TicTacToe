//
//  AppearanceServiceTests.swift
//  ShapeDuelTests
//
//  Created by Churkin Vitaly on 04.10.2026.
//

import Testing
import UIKit
@testable import ShapeDuel

struct AppearanceServiceTests {

    @Test(arguments: [
        (Theme.system, UIUserInterfaceStyle.unspecified),
        (Theme.light, UIUserInterfaceStyle.light),
        (Theme.dark, UIUserInterfaceStyle.dark)
    ])
    func themeSetsWindowStyle(theme: Theme, style: UIUserInterfaceStyle) {
        let window = UIWindow()
        let appearance = AppearanceService(window: window)

        appearance.apply(theme, animated: false)

        #expect(window.overrideUserInterfaceStyle == style)
    }

    @Test func animatedThemeIsSetAtOnce() {
        let window = UIWindow()
        let appearance = AppearanceService(window: window)

        appearance.apply(.dark, animated: true)

        #expect(window.overrideUserInterfaceStyle == .dark)
    }

    @Test func systemThemeRemovesOverride() {
        let window = UIWindow()
        let appearance = AppearanceService(window: window)
        appearance.apply(.dark, animated: false)

        appearance.apply(.system, animated: false)

        #expect(window.overrideUserInterfaceStyle == .unspecified)
    }
}
