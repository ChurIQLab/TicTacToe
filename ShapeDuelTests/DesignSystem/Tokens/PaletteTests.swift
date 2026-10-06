//
//  PaletteTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 15.09.2026.
//

import Testing
import UIKit

struct PaletteTests {

    @Test(arguments: PaletteColor.all)
    func colorMatchesSpecification(_ paletteColor: PaletteColor) throws {
        let color = try #require(UIColor(named: paletteColor.name))

        #expect(try hex(of: color, in: .light) == paletteColor.light)
        #expect(try hex(of: color, in: .dark) == paletteColor.dark)
    }

    @Test(arguments: ContrastPair.all, Appearance.allCases)
    func contrastMeetsMinimum(_ pair: ContrastPair, appearance: Appearance) throws {
        let foreground = try #require(UIColor(named: pair.foreground))
        let background = try #require(UIColor(named: pair.background))

        let ratio = try contrastRatio(between: foreground, and: background, in: appearance)

        #expect(ratio >= pair.minimum)
    }
}

extension PaletteTests {

    // MARK: - Private methods

    private func hex(of color: UIColor, in appearance: Appearance) throws -> String {
        let components = try components(of: color, in: appearance)
        let channels = [components.red, components.green, components.blue, components.alpha]
            .map { UInt8(($0 * 255).rounded()) }
        let opaque = String(format: "#%02X%02X%02X", channels[0], channels[1], channels[2])
        return components.alpha == 1 ? opaque : opaque + String(format: "%02X", channels[3])
    }

    private func contrastRatio(
        between first: UIColor,
        and second: UIColor,
        in appearance: Appearance
    ) throws -> Double {
        let firstLuminance = try relativeLuminance(of: first, in: appearance)
        let secondLuminance = try relativeLuminance(of: second, in: appearance)
        let lighter = max(firstLuminance, secondLuminance)
        let darker = min(firstLuminance, secondLuminance)

        return (lighter + 0.05) / (darker + 0.05)
    }

    private func relativeLuminance(of color: UIColor, in appearance: Appearance) throws -> Double {
        let components = try components(of: color, in: appearance)
        let channels = [components.red, components.green, components.blue].map { channel -> Double in
            let value = Double(channel)
            return value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2]
    }

    private func components(of color: UIColor, in appearance: Appearance) throws -> ColorComponents {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let resolved = color.resolvedColor(with: appearance.traitCollection)

        try #require(resolved.getRed(&red, green: &green, blue: &blue, alpha: &alpha))

        return ColorComponents(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - ColorComponents

nonisolated struct ColorComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

// MARK: - Appearance

nonisolated enum Appearance: CaseIterable, Sendable {
    case light
    case dark

    var traitCollection: UITraitCollection {
        switch self {
        case .light: UITraitCollection(userInterfaceStyle: .light)
        case .dark: UITraitCollection(userInterfaceStyle: .dark)
        }
    }
}

// MARK: - PaletteColor

nonisolated struct PaletteColor: Sendable, CustomTestStringConvertible {

    // MARK: - Properties

    static let all: [PaletteColor] = [
        PaletteColor(name: "ScreenBackground", light: "#F3F3F6", dark: "#0F0F12"),
        PaletteColor(name: "Surface", light: "#FFFFFF", dark: "#202024"),
        PaletteColor(name: "PrimaryText", light: "#1A1A1E", dark: "#F3F3F6"),
        PaletteColor(name: "SecondaryText", light: "#626269", dark: "#A4A4AB"),
        PaletteColor(name: "FirstSide", light: "#E45128", dark: "#FA7F59"),
        PaletteColor(name: "SecondSide", light: "#4582FA", dark: "#78A7FC"),
        PaletteColor(name: "FirstSideTint", light: "#FDF1EE", dark: "#3E2D2B"),
        PaletteColor(name: "SecondSideTint", light: "#F0F5FF", dark: "#2C3342"),
        PaletteColor(name: "PrimaryButton", light: "#1A1A1E", dark: "#F3F3F6"),
        PaletteColor(name: "PrimaryButtonText", light: "#FFFFFF", dark: "#0F0F12"),
        PaletteColor(name: "SecondaryButton", light: "#F0F0F3", dark: "#2C2C31"),
        PaletteColor(name: "SegmentTrack", light: "#E6E6EB", dark: "#202024"),
        PaletteColor(name: "SegmentTrackInCard", light: "#EDEDF1", dark: "#2C2C31"),
        PaletteColor(name: "SegmentThumb", light: "#FFFFFF", dark: "#3A3A40"),
        PaletteColor(name: "SegmentThumbInCard", light: "#FFFFFF", dark: "#48484F"),
        PaletteColor(name: "IconBackground", light: "#F7F6FA", dark: "#17171B"),
        PaletteColor(name: "Scrim", light: "#0F0F1440", dark: "#00000080"),
        PaletteColor(name: "AccentColor", light: "#1A1A1E", dark: "#F3F3F6")
    ]

    let name: String
    let light: String
    let dark: String

    var testDescription: String {
        name
    }
}

// MARK: - ContrastPair

nonisolated struct ContrastPair: Sendable, CustomTestStringConvertible {

    // MARK: - Properties

    static let all: [ContrastPair] = [
        ContrastPair(foreground: "PrimaryText", background: "ScreenBackground", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "Surface", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "FirstSideTint", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "SecondSideTint", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "SecondaryButton", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "SegmentThumb", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryText", background: "SegmentThumbInCard", minimum: textMinimum),
        ContrastPair(foreground: "PrimaryButtonText", background: "PrimaryButton", minimum: textMinimum),
        ContrastPair(foreground: "SecondaryText", background: "ScreenBackground", minimum: textMinimum),
        ContrastPair(foreground: "SecondaryText", background: "Surface", minimum: textMinimum),
        ContrastPair(foreground: "SecondaryText", background: "SegmentTrack", minimum: textMinimum),
        ContrastPair(foreground: "SecondaryText", background: "SegmentTrackInCard", minimum: textMinimum),
        ContrastPair(foreground: "FirstSide", background: "Surface", minimum: figureMinimum),
        ContrastPair(foreground: "SecondSide", background: "Surface", minimum: figureMinimum),
        ContrastPair(foreground: "FirstSide", background: "FirstSideTint", minimum: figureMinimum),
        ContrastPair(foreground: "SecondSide", background: "SecondSideTint", minimum: figureMinimum),
        ContrastPair(foreground: "FirstSide", background: "IconBackground", minimum: figureMinimum),
        ContrastPair(foreground: "SecondSide", background: "IconBackground", minimum: figureMinimum)
    ]

    private static let textMinimum = 4.5
    private static let figureMinimum = 3.0

    let foreground: String
    let background: String
    let minimum: Double

    var testDescription: String {
        "\(foreground) on \(background)"
    }
}
