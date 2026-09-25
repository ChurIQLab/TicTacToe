//
//  MenuViewSpy.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

@testable import TicTacToe

final class MenuViewSpy {

    // MARK: - Properties

    private(set) var items: [[MenuItemViewModel]] = []
}

// MARK: - MenuViewProtocol

extension MenuViewSpy: MenuViewProtocol {
    func showItems(_ items: [MenuItemViewModel]) {
        self.items.append(items)
    }
}
