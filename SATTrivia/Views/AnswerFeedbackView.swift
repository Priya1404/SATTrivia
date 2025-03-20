//
//  AnswerFeedbackView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct AnswerFeedbackView: View {
    let result: PlayerResult
    let onContinue: () -> Void
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 20) {
            Text(result.isCorrect ? "Correct! 🎉" : "Incorrect 😢")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(result.isCorrect ? .green : .red)
            
            Text("Time: \(String(format: "%.1f", result.time))s")
                .font(.headline)
                .foregroundColor(.white)
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
    }
}
