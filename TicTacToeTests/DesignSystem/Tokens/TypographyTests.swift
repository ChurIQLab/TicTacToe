//
//  TypographyTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import Testing
import UIKit
@testable import TicTacToe

struct TypographyTests {

    // MARK: - Properties

    private let defaultContentSize = UITraitCollection(preferredContentSizeCategory: .large)
    private let largestContentSize = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)

    // MARK: - Tests

    @Test(arguments: Typography.allCases)
    func fontIsRoundedWithRoleSizeAndWeight(_ role: Typography) {
        let font = role.font(compatibleWith: defaultContentSize)

        #expect(font.pointSize == role.pointSize)
        #expect(weight(of: font) == role.weight)
        #expect(font.familyName != UIFont.systemFont(ofSize: role.pointSize).familyName)
    }

    @Test(arguments: Typography.allCases)
    func fontGrowsWithDynamicType(_ role: Typography) {
        #expect(role.font(compatibleWith: largestContentSize).pointSize > role.pointSize)
    }

    @Test func scoreDigitsHaveEqualWidth() {
        let font = Typography.score.font(compatibleWith: defaultContentSize)
        let widths = ["1", "8"].map { NSAttributedString(string: $0, attributes: [.font: font]).size().width }

        #expect(widths[0] == widths[1])
    }
}

extension TypographyTests {

    // MARK: - Private methods

    private func weight(of font: UIFont) -> UIFont.Weight? {
        let traits = font.fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        guard let rawValue = traits?[.weight] as? CGFloat else { return nil }
        return UIFont.Weight(rawValue: rawValue)
    }
}
