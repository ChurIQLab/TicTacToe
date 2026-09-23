//
//  GameContract.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 12.09.2026.
//

protocol GameViewProtocol: AnyObject {
    func setTitle(_ title: String)
    func showFigure(_ figure: Figure, for side: Side, at position: Position)
    func resetBoard()
    func updatePlayers(_ players: [PlayerCardViewModel])
    func showGameOver(message: String)
}

protocol GamePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCell(at position: Position)
    func didTapNewGame()
}
