//
//  SeededRandomNumberGenerator.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 26.09.2026.
//

/// SplitMix64: the same seed gives the same numbers, so the random moves repeat
struct SeededRandomNumberGenerator: RandomNumberGenerator {

    // MARK: - Properties

    private var state: UInt64

    // MARK: - Initial

    init(seed: UInt64) {
        state = seed
    }

    // MARK: - Methods

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var value = state
        value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
        value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
        return value ^ (value >> 31)
    }
}
