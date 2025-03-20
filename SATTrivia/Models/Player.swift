//
//  Player.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import Foundation

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
    
    mutating func updateScore() {
        score += 1
    }
}

struct Players: Codable {
    var player1: Player?
    var player2: Player?
    
    init(player1: Player?, player2: Player?) {
        self.player1 = player1
        self.player2 = player2
    }
}
