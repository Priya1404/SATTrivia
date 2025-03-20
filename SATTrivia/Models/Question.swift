//
//  Question.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    
    init(id: UUID = UUID(), text: String, options: [String], correctAnswer: Int, explanation: String) {
        self.id = id
        self.text = text
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
    }
}
