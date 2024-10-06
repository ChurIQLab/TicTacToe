//
//  GameModel.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

struct GameModel {
    var board: [[String]]
    var players: [Player]
    var currentPlayerIndex: Int
    var isGameOver: Bool

    init() {
        self.board = Array(repeating: Array(repeating: "", count: 3), count: 3)
        self.players = [Player(name: "Player 1", symbol: "X"), Player(name: "Player 2", symbol: "O")]
        self.currentPlayerIndex = 0
        self.isGameOver = false
    }

    var currentPlayer: Player { players[currentPlayerIndex] }
}
