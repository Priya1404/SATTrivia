import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState()
    @State private var playerName = ""
    @State private var startTime: Date?
    @State private var selectedAnswer: Int?
    @State private var showingResults = false
    @State private var showLosingStreak = false
    @State private var consecutiveLosses = 0
    
    var body: some View {
        ZStack {
            Color.pastelBackground
                .ignoresSafeArea()
            
            VStack {
                switch gameState.gameStatus {
                case .waiting:
                    setupView
                case .inProgress:
                    gamePlayView
                case .finished:
                    if let player = gameState.players.player1 {
                        GameOverView(
                            winner: player,
                            loser: Player(name: "Computer"),
                            rounds: gameState.rounds,
                            onPlayAgain: resetGame
                        )
                    }
                }
            }
        }
        .alert("Keep Going!", isPresented: $showLosingStreak) {
            Button("I Can Do This! 💪") {
                showLosingStreak = false
            }
        } message: {
            Text("Don't give up! Every great mathematician started somewhere. Keep trying!")
        }
    }
    
    private var setupView: some View {
        VStack(spacing: 20) {
            Text("SAT Math Trivia")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.pastelBlue)
            
            VStack(spacing: 15) {
                TextField("Your Name", text: $playerName)
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
                        playerName.isEmpty ?
                        Color.pastelGray : Color.pastelBlue
                    )
                    .cornerRadius(10)
            }
            .disabled(playerName.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var gamePlayView: some View {
        VStack(spacing: 20) {
            // Score display
            HStack {
                PlayerScoreView(
                    name: gameState.players.player1?.name ?? "",
                    score: gameState.players.player1?.score ?? 0,
                    isActive: true
                )
                
                PlayerScoreView(
                    name: "Computer",
                    score: gameState.players.player2?.score ?? 0,
                    isActive: false
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
            
            // Timer display
            if let startTime = startTime {
                TimerView(startTime: startTime)
            }
        }
        .padding()
        .alert("Round Results", isPresented: $showingResults) {
            Button("Continue") {
                startNextRound()
            }
        } message: {
            if let round = gameState.rounds.last {
                RoundResultView(round: round)
            }
        }
    }
    
    private func startGame() {
        let player = Player(name: playerName)
        let computer = Player(name: "Computer")
        gameState.startNewGame(player1: player, player2: computer)
        consecutiveLosses = 0
        startNextRound()
    }
    
    private func startNextRound() {
        gameState.currentQuestion = QuestionBank.getRandomQuestion()
        startTime = Date()
        selectedAnswer = nil
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = index
        let time = Date().timeIntervalSince(startTime ?? Date())
        
        if let player = gameState.players.player1 {
            let isCorrect = index == gameState.currentQuestion?.correctAnswer
            let result = PlayerResult(
                playerId: player.id,
                answer: index,
                time: time,
                isCorrect: isCorrect
            )
            
            // Generate computer's answer
            let computerResult = generateComputerResult(question: gameState.currentQuestion!)
            
            gameState.player1Result = result
            gameState.player2Result = computerResult
            
            if let player1Result = gameState.player1Result,
               let player2Result = gameState.player2Result {
                gameState.endRound(
                    player1Result: player1Result,
                    player2Result: player2Result
                )
                
                // Handle losing streak
                if !isCorrect {
                    consecutiveLosses += 1
                    if consecutiveLosses >= 3 {
                        showLosingStreak = true
                    }
                } else {
                    consecutiveLosses = 0
                }
                
                showingResults = true
            }
        }
    }
    
    private func generateComputerResult(question: Question) -> PlayerResult {
        // Computer has 70% chance of getting it right
        let isCorrect = Double.random(in: 0...1) < 0.7
        let answer = isCorrect ? question.correctAnswer : Int.random(in: 0..<question.options.count)
        let time = Double.random(in: 2...5) // Computer takes 2-5 seconds
        
        return PlayerResult(
            playerId: gameState.players.player2!.id,
            answer: answer,
            time: time,
            isCorrect: isCorrect
        )
    }
    
    private func resetGame() {
        gameState.reset()
        playerName = ""
        consecutiveLosses = 0
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
        .background(isActive ? Color.pastelBlue.opacity(0.2) : Color.clear)
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
            return .pastelBlue
        } else if isHovered {
            return .pastelGray.opacity(0.8)
        } else {
            return .pastelGray.opacity(0.6)
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return .pastelBlue.opacity(0.5)
        } else if isHovered {
            return .pastelGray.opacity(0.3)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Player 1: \(round.player1Result.isCorrect ? "Correct" : "Incorrect") in \(String(format: "%.1f", round.player1Result.time))s")
            Text("Player 2: \(round.player2Result.isCorrect ? "Correct" : "Incorrect") in \(String(format: "%.1f", round.player2Result.time))s")
            if let winner = round.winner {
                Text("Winner: \(winner == round.player1Result.playerId ? "Player 1" : "Player 2")")
            } else {
                Text("Tie!")
            }
        }
    }
}

#Preview {
    GameView()
} 
