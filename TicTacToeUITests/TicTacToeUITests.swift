//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import XCTest

final class TicTacToeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
