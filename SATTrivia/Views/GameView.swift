import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState()
    @State private var player1Name = ""
    @State private var player2Name = ""
    @State private var startTime: Date?
    @State private var selectedAnswer: Int?
    @State private var isTimerRunning = false
    @State private var showPassPhoneAlert = false
    @State private var showAnswerFeedback = false
    @State private var showRoundResult = false
    @State private var currentAnswerResult: PlayerResult?
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                switch gameState.gameStatus {
                case .waiting:
                    setupView
                case .inProgress:
                    gamePlayView
                case .finished:
                    if let player1 = gameState.players.player1,
                       let player2 = gameState.players.player2 {
                        GameOverView(
                            winner: player1.score >= 2 ? player1 : player2,
                            loser: player1.score >= 2 ? player2 : player1,
                            rounds: gameState.rounds,
                            onPlayAgain: resetGame
                        )
                    }
                }
            }
        }
        .alert("Pass the Phone", isPresented: $showPassPhoneAlert) {
            Button("OK") {
                startTimer()
            }
        } message: {
            if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
                gameState.players.player1 : gameState.players.player2 {
                Text("Please pass the phone to \(currentPlayer.name)")
            }
        }
        .sheet(isPresented: $showAnswerFeedback) {
            if let result = currentAnswerResult {
                AnswerFeedbackView(result: result) {
                    showAnswerFeedback = false
                    showPassPhoneAlert = true
                }
            }
        }
        .sheet(isPresented: $showRoundResult) {
            if let player1 = gameState.players.player1,
               let player2 = gameState.players.player2,
               let lastRound = gameState.rounds.last {
                RoundResultView(
                    round: lastRound,
                    player1: player1,
                    player2: player2,
                    roundNumber: gameState.rounds.count,
                    onContinue: {
                        showRoundResult = false
                        showPassPhoneAlert = true
                    }
                )
            }
        }
    }
    
    private var setupView: some View {
        VStack(spacing: 20) {
            Text("SAT Math Trivia")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            VStack(spacing: 15) {
                TextField("Player 1 Name", text: $player1Name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Player 2 Name", text: $player2Name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        player1Name.isEmpty || player2Name.isEmpty ?
                        Color.gray : Color.blue
                    )
                    .cornerRadius(10)
            }
            .disabled(player1Name.isEmpty || player2Name.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 20) {
            // Round and Player Turn Indicator
            VStack(spacing: 10) {
                Text("Round \(gameState.currentRound)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
                    gameState.players.player1 : gameState.players.player2 {
                    Text("\(currentPlayer.name)'s Turn")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding(.vertical)
            
            // Score display
            HStack {
                PlayerScoreView(
                    name: gameState.players.player1?.name ?? "",
                    score: gameState.players.player1?.score ?? 0,
                    isActive: gameState.currentPlayerTurn == gameState.players.player1?.id
                )
                
                PlayerScoreView(
                    name: gameState.players.player2?.name ?? "",
                    score: gameState.players.player2?.score ?? 0,
                    isActive: gameState.currentPlayerTurn == gameState.players.player2?.id
                )
            }
            
            // Question display
            if let question = gameState.currentQuestion {
                QuestionView(question: question)
                
                // Answer options
                VStack(spacing: 12) {
                    ForEach(0..<question.options.count, id: \.self) { index in
                        AnswerButton(
                            text: question.options[index],
                            isSelected: selectedAnswer == index,
                            action: { selectAnswer(index) }
                        )
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    private func startGame() {
        let player1 = Player(name: player1Name)
        let player2 = Player(name: player2Name)
        gameState.startNewGame(player1: player1, player2: player2)
        showPassPhoneAlert = true
    }
    
    private func startTimer() {
        startTime = Date()
        isTimerRunning = true
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = nil
        isTimerRunning = false
        let time = Date().timeIntervalSince(startTime ?? Date())
        
        if let currentPlayer = gameState.currentPlayerTurn == gameState.players.player1?.id ?
            gameState.players.player1 : gameState.players.player2 {
            
            let isCorrect = index == gameState.currentQuestion?.correctAnswer
            let result = PlayerResult(
                playerId: currentPlayer.id,
                answer: index,
                time: time,
                isCorrect: isCorrect
            )
            
            currentAnswerResult = result
            gameState.endPlayerTurn(playerResult: result)
            
            if gameState.currentPlayerTurn == gameState.players.player2?.id {
                showAnswerFeedback = true
            } else {
                showRoundResult = true
            }
        }
    }
    
    private func resetGame() {
        gameState.reset()
        player1Name = ""
        player2Name = ""
    }
}

struct AnswerFeedbackView: View {
    let result: PlayerResult
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(result.isCorrect ? "Correct! 🎉" : "Incorrect 😢")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(result.isCorrect ? .green : .red)
            
            Text("Time: \(String(format: "%.1f", result.time))s")
                .font(.headline)
                .foregroundColor(.white)
            
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
    }
}

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

struct QuestionView: View {
    let question: Question
    
    var body: some View {
        Text(question.text)
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding()
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
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

struct TimerView: View {
    let startTime: Date
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(String(format: "%.1f", currentTime.timeIntervalSince(startTime)))
            .font(.title)
            .fontWeight(.bold)
            .onReceive(timer) { input in
                currentTime = input
            }
    }
}

struct RoundResultView: View {
    let round: RoundResult
    let player1: Player
    let player2: Player
    let roundNumber: Int
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Round \(roundNumber)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // Player Results
            VStack(spacing: 20) {
                if let player1Result = round.player1Result {
                    PlayerRoundResultRow(
                        name: player1.name,
                        isCorrect: player1Result.isCorrect,
                        time: player1Result.time,
                        isWinner: round.winner == player1Result.playerId
                    )
                }
                
                if let player2Result = round.player2Result {
                    PlayerRoundResultRow(
                        name: player2.name,
                        isCorrect: player2Result.isCorrect,
                        time: player2Result.time,
                        isWinner: round.winner == player2Result.playerId
                    )
                }
            }
            
            // Current Score
            HStack(spacing: 30) {
                VStack {
                    Text(player1.name)
                        .font(.headline)
                    Text("\(player1.score)")
                        .font(.title)
                        .foregroundColor(.green)
                }
                
                VStack {
                    Text(player2.name)
                        .font(.headline)
                    Text("\(player2.score)")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.pastelBlue.opacity(0.3))
            .cornerRadius(15)
            
            Button(action: onContinue) {
                Text("Continue to Next Round")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pastelGreen)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.pastelBackground)
        .cornerRadius(20)
    }
}

struct PlayerRoundResultRow: View {
    let name: String
    let isCorrect: Bool
    let time: TimeInterval
    let isWinner: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(String(format: "%.1f", time))s")
                    .foregroundColor(.black)
            }
            
            HStack {
                Text(isCorrect ? "✅ Correct" : "❌ Incorrect")
                    .foregroundColor(isCorrect ? .green : .red)
                
                Spacer()
                
                if isWinner {
                    Text("👑 Winner")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding()
        .background(Color.pastelBlue.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    GameView()
} 
