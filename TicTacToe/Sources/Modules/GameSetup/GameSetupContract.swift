//
//  GameSetupContract.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 25.09.2026.
//

protocol GameSetupViewProtocol: AnyObject {
    func setTitle(_ title: String)
    /// Two players: a name field and a row of figures for each
    func showPlayers(_ players: [PlayerSetupViewModel], hint: String)
    /// Against the computer: the player's figures under a section label
    func showFigurePicker(_ picker: FigurePickerViewModel, label: String, hint: String)
    func updateFigurePickers(_ pickers: [FigurePickerViewModel])
}

protocol GameSetupPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeName(_ name: String, for side: Side)
    func didSelectFigure(_ figure: Figure, for side: Side)
    func didTapPlay()
}

protocol GameSetupRouting: AnyObject {
    func showGame(configuration: GameConfiguration)
}
