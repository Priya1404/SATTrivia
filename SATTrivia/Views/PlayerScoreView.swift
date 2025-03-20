//
//  PlayerScoreView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct PlayerScoreView: View {
    let name: String
    let score: Int
    let isActive: Bool
    
    var body: some View {
        VStack {
            Text(name)
                .font(.headline)
            Text("\(score)")
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .background(isActive ? Color.blue.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
}
