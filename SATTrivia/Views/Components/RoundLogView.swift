import SwiftUI

struct RoundLogView: View {
    let roundNumber: Int
    let result: PlayerResult
    let isWinner: Bool
    let playerName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Round \(roundNumber)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(String(format: "%.1f", result.time))s")
                    .foregroundColor(.black)
            }
            
            HStack {
                Text(playerName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text(result.isCorrect ? "✅ Correct" : "❌ Incorrect")
                    .foregroundColor(result.isCorrect ? .green : .red)
            }
            
            if isWinner {
                HStack {
                    Spacer()
                    Text("👑 Round Winner")
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