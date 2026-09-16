//
//  Typography.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import UIKit

nonisolated enum Typography: CaseIterable, Sendable {
    case largeTitle
    case title
    case score
    case accent
    case body
    case caption
    case captionBold
    case sectionLabel
    case small

    // MARK: - Properties

    var pointSize: CGFloat {
        switch self {
        case .largeTitle: 34
        case .title: 28
        case .score: 32
        case .accent, .body: 17
        case .caption, .captionBold: 15
        case .sectionLabel, .small: 13
        }
    }

    var weight: UIFont.Weight {
        switch self {
        case .largeTitle, .title, .score, .sectionLabel: .heavy
        case .accent, .captionBold: .bold
        case .body, .caption, .small: .semibold
        }
    }

    /// Letter spacing in em
    var tracking: CGFloat {
        switch self {
        case .sectionLabel: 0.06
        case .largeTitle, .title, .score, .accent, .body, .caption, .captionBold, .small: 0
        }
    }

    var isUppercased: Bool {
        switch self {
        case .sectionLabel: true
        case .largeTitle, .title, .score, .accent, .body, .caption, .captionBold, .small: false
        }
    }

    private var textStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle, .score: .largeTitle
        case .title: .title1
        case .accent: .headline
        case .body: .body
        case .caption, .captionBold: .subheadline
        case .sectionLabel, .small: .footnote
        }
    }

    // MARK: - Methods

    func font(compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        let roundedFont = UIFont.rounded(ofSize: pointSize, weight: weight)
        let font = self == .score ? monospacedDigits(roundedFont) : roundedFont
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font, compatibleWith: traitCollection)
    }

    // MARK: - Private methods

    private func monospacedDigits(_ font: UIFont) -> UIFont {
        let featureSettings: [[UIFontDescriptor.FeatureKey: Int]] = [
            [.type: kNumberSpacingType, .selector: kMonospacedNumbersSelector]
        ]
        let descriptor = font.fontDescriptor.addingAttributes([.featureSettings: featureSettings])
        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
}

// MARK: - UIFont

extension UIFont {
    nonisolated static func rounded(ofSize size: CGFloat, weight: Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        guard let descriptor = systemFont.fontDescriptor.withDesign(.rounded) else { return systemFont }
        return UIFont(descriptor: descriptor, size: size)
    }
}
