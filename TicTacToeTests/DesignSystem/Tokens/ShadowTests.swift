//
//  ShadowTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import Testing
import UIKit
@testable import TicTacToe

struct ShadowTests {

    @Test func cardShadowMatchesSpecificationInLightTheme() {
        let layers = layersWithCardShadow(in: .light)

        #expect(layers.map(\.shadowOffset.height) == [1, 6])
        #expect(layers.map(\.shadowRadius) == [1, 8])
        #expect(layers.map(\.shadowOpacity) == [0.05, 0.05])
    }

    @Test func cardShadowIsHiddenInDarkTheme() {
        let layers = layersWithCardShadow(in: .dark)

        #expect(layers.allSatisfy { $0.shadowOpacity == 0 })
    }
}

extension ShadowTests {

    // MARK: - Private methods

    private func layersWithCardShadow(in style: UIUserInterfaceStyle) -> [CALayer] {
        let traitCollection = UITraitCollection(userInterfaceStyle: style)
        return Shadow.card.map { shadow in
            let layer = CALayer()
            shadow.apply(to: layer, for: traitCollection)
            return layer
        }
    }
}
