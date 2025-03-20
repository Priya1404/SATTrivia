//
//  GameState.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import Foundation

enum GameStatus: String, Codable {
    case waiting
    case inProgress
    case finished
}

class GameState: ObservableObject {
    @Published var players: Players
    @Published var currentQuestion: Question?
    @Published var rounds: [RoundResult]
    @Published var gameStatus: GameStatus
    @Published var player1Result: PlayerResult?
    @Published var player2Result: PlayerResult?
    @Published var currentRound: Int
    @Published var currentPlayerTurn: UUID?
    @Published var showRoundResults: Bool
    
    private var player2Answers: [UUID: PlayerResult] = [:]
    
    init() {
        self.players = Players(player1: nil, player2: nil)
        self.rounds = []
        self.gameStatus = .waiting
        self.currentRound = 1
        self.currentPlayerTurn = nil
        self.showRoundResults = false
    }
    
    func startNewGame(player1: Player, player2: Player) {
        players = Players(player1: player1, player2: player2)
        rounds = []
        gameStatus = .inProgress
        player1Result = nil
        player2Result = nil
        player2Answers = [:]
        currentRound = 1
        currentPlayerTurn = player1.id // Player 1 starts first
        showRoundResults = false
        
        // Start with first question
        currentQuestion = QuestionBank.getRandomQuestion()
    }
    
    func getPlayer2Result(for question: Question) -> PlayerResult? {
        return player2Answers[question.id]
    }
    
    func endPlayerTurn(playerResult: PlayerResult) {
        if playerResult.playerId == players.player1?.id {
            player1Result = playerResult
            currentPlayerTurn = players.player2?.id
        } else if playerResult.playerId == players.player2?.id {
            player2Result = playerResult
            endRound()
        }
    }
    
    func endRound() {
        guard let question = currentQuestion,
              let player1Result = player1Result,
              let player2Result = player2Result else { return }
        
        // Determine winner
        let winner: UUID?
        if player1Result.isCorrect && !player2Result.isCorrect {
            winner = player1Result.playerId
        } else if !player1Result.isCorrect && player2Result.isCorrect {
            winner = player2Result.playerId
        } else {
            winner = nil // Tie
        }
        
        let round = RoundResult(
            id: UUID(),
            player1Result: player1Result,
            player2Result: player2Result,
            winner: winner,
            question: question
        )
        
        rounds.append(round)
        
        // Update scores
        if var player1 = players.player1, player1Result.playerId == player1.id {
            if player1Result.isCorrect {
                player1.updateScore()
                players.player1 = player1
            }
        }
        
        if var player2 = players.player2, player2Result.playerId == player2.id {
            if player2Result.isCorrect {
                player2.updateScore()
                players.player2 = player2
            }
        }
        
        // Check for game end or start next round
        if currentRound >= 3 {
            gameStatus = .finished
        } else {
            currentRound += 1
            currentQuestion = QuestionBank.getRandomQuestion()
            self.player1Result = nil
            self.player2Result = nil
            showRoundResults = false
            
            // Always start with Player 1 in each round
            currentPlayerTurn = players.player1?.id
        }
    }
    
    func getGameWinner() -> (winner: Player?, loser: Player?)? {
        guard let player1 = players.player1,
              let player2 = players.player2 else { return nil }
        
        if player1.score > player2.score {
            return (player1, player2)
        } else if player2.score > player1.score {
            return (player2, player1)
        } else {
            return nil // Tie
        }
    }
    
    func reset() {
        players = Players(player1: nil, player2: nil)
        currentQuestion = nil
        rounds = []
        gameStatus = .waiting
        player1Result = nil
        player2Result = nil
        player2Answers = [:]
        currentRound = 1
        currentPlayerTurn = nil
        showRoundResults = false
    }
    
    func updateScore(for playerId: UUID, isCorrect: Bool) {
        if playerId == players.player1?.id {
            if isCorrect {
                players.player1?.score += 1
            }
        } else if playerId == players.player2?.id {
            if isCorrect {
                players.player2?.score += 1
            }
        }
    }
    
    func nextPlayer() {
        if currentPlayerTurn == players.player1?.id {
            currentPlayerTurn = players.player2?.id
        } else if currentPlayerTurn == players.player2?.id {
            currentPlayerTurn = players.player1?.id
            currentRound += 1
            
            if currentRound > 5 {
                gameStatus = .finished
            }
        }
    }
} 
