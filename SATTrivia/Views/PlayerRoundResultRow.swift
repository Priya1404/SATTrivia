//
//  PlayerRoundResultRow.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct PlayerRoundResultRow: View {
    let name: String
    let isCorrect: Bool
    let time: TimeInterval
    let isWinner: Bool
    let answerIndex: Int
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(String(format: "%.1f", time))s")
                    .foregroundColor(.black)
            }
            
            HStack {
                Text("Answer: \(options[answerIndex])")
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(isCorrect ? "✅ Correct" : "❌ Incorrect")
                    .foregroundColor(isCorrect ? .green : .red)
            }
            
            if isWinner {
                HStack {
                    Spacer()
                    Text("👑 Winner")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .background(Color.pastelBlue.opacity(0.3))
        .cornerRadius(10)
    }
}
