//
//  GameOverView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import SwiftUI

struct GameOverView: View {
    @StateObject private var viewModel: GameOverViewModel
    @Environment(\.dismiss) private var dismiss
    let resetGame: () -> Void
    
    init(winner: Player, loser: Player, rounds: [RoundResult], isTie: Bool = false, resetGame: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: GameOverViewModel(
            winner: winner,
            loser: loser,
            rounds: rounds,
            isTie: isTie
        ))
        self.resetGame = resetGame
    }
    
    var body: some View {
        ZStack {
            Color.pastelBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    winnerCelebrationView
                    scoreDisplayView
                    actionButtonsView
                    logsView
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.showConfetti = true
        }
    }
    
    private var winnerCelebrationView: some View {
        VStack(spacing: 20) {
            if viewModel.showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
            
            Text(viewModel.isTie ? "It's a Tie! 🤝" : "\(viewModel.winner.name) Wins! 🎉")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(viewModel.isTie ? .orange : .green)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            if viewModel.isTie {
                Text("Both players played brilliantly!")
                    .font(.title3)
                    .foregroundColor(.gray)
            } else {
                Text("Congratulations on your victory!")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var scoreDisplayView: some View {
        HStack(spacing: 20) {
            PlayerResultCard(
                player: viewModel.winner,
                isWinner: true,
                emoji: "👑",
                showGif: $viewModel.showWinnerGif
            )
            
            PlayerResultCard(
                player: viewModel.loser,
                isWinner: false,
                emoji: "💪",
                showGif: $viewModel.showLoserGif
            )
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 15) {
            Button(action: viewModel.toggleLogs) {
                HStack {
                    Image(systemName: viewModel.showLogs ? "chevron.up" : "chevron.down")
                    Text(viewModel.showLogs ? "Hide Round Logs" : "Show Round Logs")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            Button(action: {
                resetGame()
                dismiss()
            }) {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
    
    private var logsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if viewModel.showLogs {
                ForEach(Array(viewModel.rounds.enumerated()), id: \.element.id) { index, round in
                    if let player1Result = round.player1Result {
                        RoundLogView(
                            roundNumber: index + 1,
                            result: player1Result,
                            isWinner: round.winner == player1Result.playerId,
                            playerName: viewModel.winner.id == player1Result.playerId ? viewModel.winner.name : viewModel.loser.name
                        )
                    }
                    
                    if let player2Result = round.player2Result {
                        RoundLogView(
                            roundNumber: index + 1,
                            result: player2Result,
                            isWinner: round.winner == player2Result.playerId,
                            playerName: viewModel.winner.id == player2Result.playerId ? viewModel.winner.name : viewModel.loser.name
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    let sampleQuestion = Question(
        text: "What is the capital of France?",
        options: ["London", "Paris", "Berlin", "Madrid"],
        correctAnswer: 1,
        explanation: "Paris is the capital and largest city of France."
    )
    
    GameOverView(
        winner: Player(name: "Player 1"),
        loser: Player(name: "Player 2"),
        rounds: [
            RoundResult(
                player1Result: PlayerResult(playerId: UUID(), answer: 1, time: 10, isCorrect: true),
                player2Result: PlayerResult(playerId: UUID(), answer: 0, time: 15, isCorrect: false),
                winner: UUID(),
                question: sampleQuestion
            ),
            RoundResult(
                player1Result: PlayerResult(playerId: UUID(), answer: 2, time: 12, isCorrect: false),
                player2Result: PlayerResult(playerId: UUID(), answer: 3, time: 8, isCorrect: true),
                winner: UUID(),
                question: sampleQuestion
            ),
            RoundResult(
                player1Result: PlayerResult(playerId: UUID(), answer: 1, time: 20, isCorrect: true),
                player2Result: PlayerResult(playerId: UUID(), answer: 0, time: 25, isCorrect: false),
                winner: UUID(),
                question: sampleQuestion
            )
        ],
        resetGame: {}
    )
} 
