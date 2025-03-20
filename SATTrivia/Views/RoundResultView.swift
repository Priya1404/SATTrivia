//
//  RoundResultView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct RoundResultView: View {
    let round: RoundResult
    let player1: Player
    let player2: Player
    let roundNumber: Int
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Round \(roundNumber)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // Question
            Text(round.question.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Player Results
            VStack(spacing: 20) {
                if let player1Result = round.player1Result {
                    PlayerRoundResultRow(
                        name: player1.name,
                        isCorrect: player1Result.isCorrect,
                        time: player1Result.time,
                        isWinner: round.winner == player1Result.playerId,
                        answerIndex: player1Result.answer,
                        options: round.question.options
                    )
                }
                
                if let player2Result = round.player2Result {
                    PlayerRoundResultRow(
                        name: player2.name,
                        isCorrect: player2Result.isCorrect,
                        time: player2Result.time,
                        isWinner: round.winner == player2Result.playerId,
                        answerIndex: player2Result.answer,
                        options: round.question.options
                    )
                }
            }
            
            // Round Winner or Tie
            if let winner = round.winner {
                Text(winner == player1.id ? "\(player1.name) Wins the Round!" : "\(player2.name) Wins the Round!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            } else {
                Text("Round Tied!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            // Round Score
            HStack(spacing: 30) {
                VStack {
                    Text(player1.name)
                        .font(.headline)
                    Text("\(round.player1Result?.isCorrect == true ? 1 : 0)")
                        .font(.title)
                        .foregroundColor(round.player1Result?.isCorrect == true ? .green : .red)
                }
                
                VStack {
                    Text(player2.name)
                        .font(.headline)
                    Text("\(round.player2Result?.isCorrect == true ? 1 : 0)")
                        .font(.title)
                        .foregroundColor(round.player2Result?.isCorrect == true ? .green : .red)
                }
            }
            .padding()
            .background(Color.pastelBlue.opacity(0.3))
            .cornerRadius(15)
            
            Button(action: onContinue) {
                Text("Continue to Next Round")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.pastelBackground)
        .cornerRadius(20)
    }
}
