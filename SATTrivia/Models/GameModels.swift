import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    
    init(id: UUID = UUID(), text: String, options: [String], correctAnswer: Int, explanation: String) {
        self.id = id
        self.text = text
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}

struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var score: Int
    var currentAnswer: Int?
    var answerTime: TimeInterval?
    
    init(id: UUID = UUID(), name: String, score: Int = 0) {
        self.id = id
        self.name = name
        self.score = score
    }
}

struct RoundResult: Identifiable, Codable {
    let id: UUID
    let player1Result: PlayerResult
    let player2Result: PlayerResult
    let winner: UUID?
    let question: Question
    
    init(id: UUID = UUID(), player1Result: PlayerResult, player2Result: PlayerResult, winner: UUID?, question: Question) {
        self.id = id
        self.player1Result = player1Result
        self.player2Result = player2Result
        self.winner = winner
        self.question = question
    }
}

struct PlayerResult: Codable {
    let playerId: UUID
    let answer: Int
    let time: TimeInterval
    let isCorrect: Bool
}

enum GameStatus: String, Codable {
    case waiting
    case inProgress
    case finished
}

class GameState: ObservableObject {
    @Published var currentRound: Int = 1
    @Published var rounds: [RoundResult] = []
    @Published var currentQuestion: Question?
    @Published var activePlayer: UUID?
    @Published var gameStatus: GameStatus = .waiting
    @Published var players: (player1: Player?, player2: Player?)
    @Published var player1Result: PlayerResult?
    @Published var player2Result: PlayerResult?
    
    init() {
        self.players = (nil, nil)
    }
    
    func startNewGame(player1: Player, player2: Player) {
        self.players = (player1, player2)
        self.currentRound = 1
        self.rounds = []
        self.gameStatus = .inProgress
        self.activePlayer = player1.id
        self.player1Result = nil
        self.player2Result = nil
    }
    
    func endRound(player1Result: PlayerResult, player2Result: PlayerResult) {
        let winner: UUID?
        if player1Result.isCorrect && !player2Result.isCorrect {
            winner = player1Result.playerId
        } else if !player1Result.isCorrect && player2Result.isCorrect {
            winner = player2Result.playerId
        } else if player1Result.isCorrect && player2Result.isCorrect {
            winner = player1Result.time < player2Result.time ? player1Result.playerId : player2Result.playerId
        } else {
            winner = nil
        }
        
        let roundResult = RoundResult(
            player1Result: player1Result,
            player2Result: player2Result,
            winner: winner,
            question: currentQuestion!
        )
        
        rounds.append(roundResult)
        
        if let winner = winner {
            if winner == players.player1?.id {
                players.player1?.score += 1
            } else {
                players.player2?.score += 1
            }
        }
        
        if players.player1?.score == 3 || players.player2?.score == 3 {
            gameStatus = .finished
        } else {
            currentRound += 1
            activePlayer = currentRound % 2 == 0 ? players.player2?.id : players.player1?.id
        }
    }
    
    func reset() {
        currentRound = 1
        rounds = []
        currentQuestion = nil
        activePlayer = nil
        gameStatus = .waiting
        players = (nil, nil)
        player1Result = nil
        player2Result = nil
    }
} 