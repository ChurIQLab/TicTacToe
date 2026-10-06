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
    func showComputerSetup(_ setup: ComputerSetupViewModel)
    func updateFigurePickers(_ pickers: [FigurePickerViewModel])
    func updateDifficultyPicker(_ picker: DifficultyPickerViewModel)
}

protocol GameSetupPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeName(_ name: String, for side: Side)
    func didSelectFigure(_ figure: Figure, for side: Side)
    /// `index` in `Difficulty.allCases`, as the segments show them
    func didSelectDifficulty(at index: Int)
    func didTapPlay()
}

protocol GameSetupRouting: AnyObject {
    func showGame(configuration: GameConfiguration)
}
