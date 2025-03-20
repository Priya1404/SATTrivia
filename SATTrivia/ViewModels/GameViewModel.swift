//
//  GameViewModel.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var gameState: GameState
    
    init() {
        self.gameState = GameState()
    }
    
    func startNewGame(player1: Player, player2: Player) {
        gameState.startNewGame(player1: player1, player2: player2)
    }
    
    func endPlayerTurn(playerResult: PlayerResult) {
        // Update score if answer is correct
        if playerResult.isCorrect {
            gameState.updateScore(for: playerResult.playerId, isCorrect: true)
        }
        
        // Add result to current round
        if gameState.currentRound == 1 {
            if let currentQuestion = gameState.currentQuestion {
                gameState.rounds.append(RoundResult(
                    player1Result: nil,
                    player2Result: nil,
                    winner: nil,
                    question: currentQuestion
                ))
            }
        }
        
        let currentRoundIndex = gameState.rounds.count - 1
        if playerResult.playerId == gameState.players.player1?.id {
            gameState.rounds[currentRoundIndex].player1Result = playerResult
        } else {
            gameState.rounds[currentRoundIndex].player2Result = playerResult
        }
        
        // Determine round winner if both players have answered
        if let player1Result = gameState.rounds[currentRoundIndex].player1Result,
           let player2Result = gameState.rounds[currentRoundIndex].player2Result {
            if player1Result.isCorrect && !player2Result.isCorrect {
                gameState.rounds[currentRoundIndex].winner = player1Result.playerId
            } else if !player1Result.isCorrect && player2Result.isCorrect {
                gameState.rounds[currentRoundIndex].winner = player2Result.playerId
            }
        }
        
        // Move to next player
        gameState.nextPlayer()
    }
    
    func reset() {
        gameState.reset()
    }
    
    var currentPlayer: Player? {
        if gameState.currentPlayerTurn == gameState.players.player1?.id {
            return gameState.players.player1
        } else {
            return gameState.players.player2
        }
    }
    
    var isPlayer1Turn: Bool {
        gameState.currentPlayerTurn == gameState.players.player1?.id
    }
    
    var currentRound: Int {
        gameState.currentRound
    }
    
    var gameStatus: GameStatus {
        gameState.gameStatus
    }
    
    var currentQuestion: Question? {
        gameState.currentQuestion
    }
    
    var player1: Player? {
        gameState.players.player1
    }
    
    var player2: Player? {
        gameState.players.player2
    }
    
    var rounds: [RoundResult] {
        gameState.rounds
    }
    
    func getGameWinner() -> (winner: Player, loser: Player)? {
        if let (winner, loser) = gameState.getGameWinner() {
            return (winner: winner!, loser: loser!)
        }
        return nil
    }
} 
