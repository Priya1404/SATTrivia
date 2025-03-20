//
//  PlayerResultCard.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import SwiftUI

struct PlayerResultCard: View {
    let player: Player
    let isWinner: Bool
    let emoji: String
    @Binding var showGif: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                showGif.toggle()
            }
        }) {
            VStack(spacing: 10) {
                Text(emoji)
                    .font(.system(size: 40))
                
                Text(player.name)
                    .font(.headline)
                
                Text("\(player.score) points")
                    .font(.title2)
                    .foregroundColor(isWinner ? .green : .red)
            }
            .padding()
            .frame(width: 150)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isWinner ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            )
        }
    }
} 
