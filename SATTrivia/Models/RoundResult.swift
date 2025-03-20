//
//  RoundResult.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import Foundation

struct RoundResult: Identifiable, Codable {
    let id: UUID
    var player1Result: PlayerResult?
    var player2Result: PlayerResult?
    var winner: UUID?
    let question: Question
    
    init(id: UUID = UUID(), player1Result: PlayerResult?, player2Result: PlayerResult?, winner: UUID?, question: Question) {
        self.id = id
        self.player1Result = player1Result
        self.player2Result = player2Result
        self.winner = winner
        self.question = question
    }
}
