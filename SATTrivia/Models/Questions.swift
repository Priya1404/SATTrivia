import Foundation

struct QuestionBank {
    static let questions: [Question] = [
        Question(
            text: "If 2x + 3 = 11, what is the value of x?",
            options: ["2", "3", "4", "5"],
            correctAnswer: 2,
            explanation: "To solve for x, subtract 3 from both sides: 2x = 8, then divide by 2: x = 4"
        ),
        Question(
            text: "What is the area of a circle with radius 3?",
            options: ["6π", "9π", "12π", "15π"],
            correctAnswer: 1,
            explanation: "Area = πr² = π(3)² = 9π"
        ),
        Question(
            text: "If f(x) = 2x² + 3x - 1, what is f(2)?",
            options: ["7", "9", "11", "13"],
            correctAnswer: 1,
            explanation: "f(2) = 2(2)² + 3(2) - 1 = 8 + 6 - 1 = 13"
        ),
        Question(
            text: "What is the slope of the line passing through points (2,4) and (4,8)?",
            options: ["1", "2", "3", "4"],
            correctAnswer: 1,
            explanation: "Slope = (y₂ - y₁)/(x₂ - x₁) = (8-4)/(4-2) = 4/2 = 2"
        ),
        Question(
            text: "If a triangle has angles measuring 45°, 45°, and 90°, what is the ratio of its sides?",
            options: ["1:1:1", "1:1:√2", "1:2:3", "2:2:3"],
            correctAnswer: 1,
            explanation: "This is a 45-45-90 triangle, where the sides are in the ratio 1:1:√2"
        )
    ]
    
    static func getRandomQuestion() -> Question {
        questions.randomElement()!
    }
} 