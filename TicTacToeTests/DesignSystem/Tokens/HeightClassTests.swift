//
//  HeightClassTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 16.09.2026.
//

import CoreGraphics
import Testing
@testable import TicTacToe

struct HeightClassTests {

    @Test(arguments: [667, 699])
    func shortScreenIsCompact(screenHeight: CGFloat) {
        #expect(HeightClass(screenHeight: screenHeight) == .compact)
    }

    @Test(arguments: [700, 812, 852])
    func tallScreenIsRegular(screenHeight: CGFloat) {
        #expect(HeightClass(screenHeight: screenHeight) == .regular)
    }
}
