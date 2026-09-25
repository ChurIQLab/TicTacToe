//
//  GameSetupContract.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

protocol GameSetupViewProtocol: AnyObject {
    func setTitle(_ title: String)
    func showNameFields(_ fields: [NameFieldViewModel], hint: String)
}

protocol GameSetupPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeName(_ name: String, for side: Side)
    func didTapPlay()
}

protocol GameSetupRouting: AnyObject {
    func showGame(configuration: GameConfiguration)
}
