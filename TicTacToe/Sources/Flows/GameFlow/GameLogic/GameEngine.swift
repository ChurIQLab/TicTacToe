//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Churkin Vitaly on 06.10.2024.
//

import Foundation

final class GameEngine {

    func updateBoard(in model: inout GameModel, atRow row: Int, col: Int) {
        model.board[row][col] = model.currentPlayer.symbol
    }

    func switchPlayers(in model: inout GameModel) {
        model.currentPlayerIndex = (model.currentPlayerIndex + 1) % model.players.count
    }

    func checkForWinner(in model: GameModel) -> String? {
        let winnigCombinations = [
            // Горизонтальные линии
            [(0, 0), (0, 1), (0, 2)],
            [(1, 0), (1, 1), (1, 2)],
            [(2, 0), (2, 1), (2, 2)],
            // Вертикальные линии
            [(0, 0), (1, 0), (2, 0)],
            [(0, 1), (1, 1), (2, 1)],
            [(0, 2), (1, 2), (2, 2)],
            // Диагональные линии
            [(0, 0), (1, 1), (2, 2)],
            [(0, 2), (1, 1), (2, 0)]
        ]

        for combination in winnigCombinations {
            let first = combination[0]
            let second = combination[1]
            let third = combination[2]

            if model.board[first.0][first.1] != "" &&
                model.board[first.0][first.1] == model.board[second.0][second.1] &&
                model.board[second.0][second.1] == model.board[third.0][third.1] {
                let winnigSymbol = model.board[first.0][first.1]
                let winner = model.players.first { $0.symbol == winnigSymbol }
                return winner?.name
            }
        }

        let isDraw = model.board.allSatisfy { row in
            row.allSatisfy { $0 != "" }
        }

        if isDraw {
            return "Draw"
        }

        return nil
    }
}
