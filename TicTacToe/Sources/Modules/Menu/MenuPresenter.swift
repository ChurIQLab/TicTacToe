//
//  MenuPresenter.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

final class MenuPresenter {

    // MARK: - Properties

    weak var view: MenuViewProtocol?
    private let router: MenuRouting

    // MARK: - Initial

    init(router: MenuRouting) {
        self.router = router
    }
}

// MARK: - MenuPresenterProtocol

extension MenuPresenter: MenuPresenterProtocol {
    func viewDidLoad() {
        let items = GameMode.allCases.map { mode in
            MenuItemViewModel(mode: mode, title: mode.title, subtitle: mode.subtitle)
        }
        view?.showItems(items)
    }

    func didSelectMode(_ mode: GameMode) {
        router.showGame(mode: mode)
    }

    func didTapSettings() {
        router.showSettings()
    }
}
