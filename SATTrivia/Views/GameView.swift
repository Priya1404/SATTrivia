//
//  GameView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState()
    @State private var player1Name = ""
    @State private var player2Name = ""
    @State private var startTime: Date?
    @State private var selectedAnswer: Int?
    @State private var isTimerRunning = false
    @State private var showPassPhoneAlert = false
    @State private var showAnswerFeedback = false
    @State private var showRoundResult = false
    @State private var currentAnswerResult: PlayerResult?
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                switch gameState.gameStatus {
                case .waiting:
                    setupView
                case .inProgress:
                    gamePlayView
                case .finished:
                    if let player1 = gameState.players.player1,
                       let player2 = gameState.players.player2 {
                        if let (winner, loser) = gameState.getGameWinner() {
                            GameOverView(
                                winner: winner!,
                                loser: loser!,
                                rounds: gameState.rounds,
                                isTie: gameState.getGameWinner() == nil,
                                resetGame: resetGame
                            )
                        } else {
                            GameOverView(
                                winner: player1,
                                loser: player2,
                                rounds: gameState.rounds,
                                isTie: true,
                                resetGame: resetGame
                            )
                        }
                    }
                }
            }
        }
        .alert("Pass the Phone", isPresented: $showPassPhoneAlert) {
            Button("OK") {
                startTimer()
            }
        } message: {
            if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
                gameState.players.player1 : gameState.players.player2 {
                Text("Please pass the phone to \(currentPlayer.name)")
            }
        }
        .sheet(isPresented: $showAnswerFeedback) {
            if let result = currentAnswerResult {
                AnswerFeedbackView(
                    result: result,
                    onContinue: {
                        showAnswerFeedback = false
                        if gameState.gameStatus == .inProgress {
                            showPassPhoneAlert = true
                        }
                    },
                    gameState: gameState
                )
            }
        }
        .sheet(isPresented: $showRoundResult) {
            if let player1 = gameState.players.player1,
               let player2 = gameState.players.player2,
               let lastRound = gameState.rounds.last {
                RoundResultView(
                    round: lastRound,
                    player1: player1,
                    player2: player2,
                    roundNumber: gameState.rounds.count,
                    onContinue: {
                        showRoundResult = false
                        if gameState.gameStatus == .inProgress {
                            showPassPhoneAlert = true
                        }
                    }
                )
            }
        }
    }
    
    private var setupView: some View {
        VStack(spacing: 20) {
            Text("SAT Math Trivia")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                TextField("Player 1 Name", text: $player1Name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Player 2 Name", text: $player2Name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        player1Name.isEmpty || player2Name.isEmpty ?
                        Color.gray : Color.blue
                    )
                    .cornerRadius(10)
            }
            .disabled(player1Name.isEmpty || player2Name.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 20) {
            // Round and Player Turn Indicator
            VStack(spacing: 10) {
                Text("Round \(gameState.currentRound)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
                    gameState.players.player1 : gameState.players.player2 {
                    Text("\(currentPlayer.name)'s Turn")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding(.vertical)
            
            // Score display
            HStack {
                PlayerScoreView(
                    name: gameState.players.player1?.name ?? "",
                    score: gameState.players.player1?.score ?? 0,
                    isActive: gameState.currentPlayerTurn == gameState.players.player1?.id
                )
                
                PlayerScoreView(
                    name: gameState.players.player2?.name ?? "",
                    score: gameState.players.player2?.score ?? 0,
                    isActive: gameState.currentPlayerTurn == gameState.players.player2?.id
                )
            }
            
            // Question display
            if let question = gameState.currentQuestion {
                QuestionView(question: question)
                
                // Answer options
                VStack(spacing: 12) {
                    ForEach(0..<question.options.count, id: \.self) { index in
                        AnswerButton(
                            text: question.options[index],
                            isSelected: selectedAnswer == index,
                            action: { selectAnswer(index) }
                        )
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    private func startGame() {
        let player1 = Player(name: player1Name)
        let player2 = Player(name: player2Name)
        gameState.startNewGame(player1: player1, player2: player2)
        showPassPhoneAlert = true
    }
    
    private func startTimer() {
        startTime = Date()
        isTimerRunning = true
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = nil
        isTimerRunning = false
        let time = Date().timeIntervalSince(startTime ?? Date())
        
        if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
            gameState.players.player1 : gameState.players.player2 {
            
            let isCorrect = index == gameState.currentQuestion?.correctAnswer
            let result = PlayerResult(
                playerId: currentPlayer.id,
                answer: index,
                time: time,
                isCorrect: isCorrect
            )
            
            currentAnswerResult = result
            gameState.endPlayerTurn(playerResult: result)
            
            if gameState.currentPlayerTurn == gameState.players.player2?.id {
                showAnswerFeedback = true
            } else {
                showRoundResult = true
            }
        }
    }
    
    private func resetGame() {
        gameState.reset()
        player1Name = ""
        player2Name = ""
    }
}

#Preview {
    GameView()
} 
