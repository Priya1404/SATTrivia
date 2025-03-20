//
//  PlayerResult.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import Foundation

struct PlayerResult: Codable {
    var playerId: UUID
    var answer: Int
    var time: TimeInterval
    var isCorrect: Bool
}
