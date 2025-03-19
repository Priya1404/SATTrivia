import SwiftUI

struct GameOverView: View {
    let winner: Player
    let loser: Player
    let rounds: [RoundResult]
    let onPlayAgain: () -> Void
    
    @State private var showConfetti = false
    @State private var showLogs = false
    @State private var showWinnerGif = false
    @State private var showLoserGif = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Winner Celebration
                    VStack(spacing: 15) {
                        Text("🎉 Game Over! 🎉")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("\(winner.name) Wins!")
                            .font(.title)
                            .foregroundColor(.green)
                        
                        Text("🏆")
                            .font(.system(size: 60))
                            .scaleEffect(showConfetti ? 1.2 : 1.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5), value: showConfetti)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.3))
                    )
                    
                    // Score Display
                    HStack(spacing: 30) {
                        PlayerResultCard(
                            player: winner,
                            isWinner: true,
                            emoji: "👑",
                            showGif: $showWinnerGif
                        )
                        
                        PlayerResultCard(
                            player: loser,
                            isWinner: false,
                            emoji: "💪",
                            showGif: $showLoserGif
                        )
                    }
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        Button(action: { showLogs.toggle() }) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text(showLogs ? "Hide Question Logs" : "Show Question Logs")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        Button(action: onPlayAgain) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Play Again")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Question Logs
                    if showLogs {
                        VStack(spacing: 15) {
                            ForEach(Array(rounds.enumerated()), id: \.element.id) { index, round in
                                RoundLogView(round: round, roundNumber: index + 1)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.3))
                        )
                    }
                }
                .padding()
            }
            
            if showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }
            
            if showWinnerGif {
                GifView(gifName: "winner")
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
            
            if showLoserGif {
                GifView(gifName: "loser")
                    .frame(width: 200, height: 200)
                    .transition(.scale)
            }
        }
        .onAppear {
            withAnimation {
                showConfetti = true
            }
        }
    }
}

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

struct GifView: View {
    let gifName: String
    
    var body: some View {
        // We'll need to implement this view to display GIFs
        // For now, we'll use a placeholder
        Image(systemName: gifName == "winner" ? "star.fill" : "cloud.rain.fill")
            .font(.system(size: 60))
            .foregroundColor(gifName == "winner" ? .yellow : .gray)
    }
}

struct RoundLogView: View {
    let round: RoundResult
    let roundNumber: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Round \(roundNumber)")
                .font(.headline)
                .foregroundColor(.pastelBlue)
            
            Text(round.question.text)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("Player 1: \(((round.player1Result?.isCorrect) != nil) ? "✓" : "✗")")
                    .foregroundColor(((round.player1Result?.isCorrect) != nil) ? .pastelGreen : .pastelRed)
                Text("\(String(format: "%.1f", round.player1Result?.time ?? 0.0))s")
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Player 2: \(((round.player2Result?.isCorrect) != nil) ? "✓" : "✗")")
                    .foregroundColor(((round.player2Result?.isCorrect) != nil) ? .pastelGreen : .pastelRed)
                Text("\(String(format: "%.1f", round.player2Result?.time ?? 0.0))s")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }
}

// Pastel Colors Extension
extension Color {
    static let pastelBlue = Color(red: 174/255, green: 198/255, blue: 207/255)
    static let pastelGreen = Color(red: 167/255, green: 232/255, blue: 189/255)
    static let pastelRed = Color(red: 255/255, green: 183/255, blue: 197/255)
    static let pastelGray = Color(red: 201/255, green: 201/255, blue: 201/255)
    static let pastelBackground = Color(red: 245/255, green: 245/255, blue: 245/255)
} 
