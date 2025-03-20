//
//  QuestionView.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct QuestionView: View {
    let question: Question
    
    var body: some View {
        Text(question.text)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
    }
}
