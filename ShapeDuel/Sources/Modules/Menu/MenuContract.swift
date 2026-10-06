//
//  MenuContract.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

protocol MenuViewProtocol: AnyObject {
    func showItems(_ items: [MenuItemViewModel])
}

protocol MenuPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectMode(_ mode: GameMode)
    func didTapSettings()
}

protocol MenuRouting: AnyObject {
    func showGameSetup(mode: GameMode)
    func showSettings()
}
