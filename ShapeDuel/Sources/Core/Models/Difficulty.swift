//
//  Difficulty.swift
//  ShapeDuel
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// Raw values are stored in the settings, so they must not change
nonisolated enum Difficulty: String, CaseIterable, Sendable {
    case easy
    case medium
    case hard
}
