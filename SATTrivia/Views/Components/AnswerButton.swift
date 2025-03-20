//
//  AnswerButton.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 20/03/25.
//

import SwiftUI

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                        .shadow(color: shadowColor, radius: isHovered ? 5 : 2)
                )
                .scaleEffect(isHovered ? 1.02 : 1.0)
                .animation(.spring(response: 0.3), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isHovered {
            return .gray.opacity(0.3)
        } else {
            return .gray.opacity(0.2)
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return .blue.opacity(0.5)
        } else if isHovered {
            return .gray.opacity(0.3)
        } else {
            return .clear
        }
    }
}
