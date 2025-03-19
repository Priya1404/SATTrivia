import SwiftUI

struct GameView: View {
    @StateObject private var gameState = GameState()
    @State private var player1Name = ""
    @State private var player2Name = ""
    @State private var startTime: Date?
    @State private var selectedAnswer: Int?
    @State private var showingResults = false
    @State private var isPlayer1Turn = true
    
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
                    gameOverView
                }
            }
        }
    }
    
    private var setupView: some View {
        VStack(spacing: 20) {
            Text("SAT Math Trivia")
                .font(.largeTitle)
                .fontWeight(.bold)
            
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
            // Score display
            HStack {
                PlayerScoreView(
                    name: gameState.players.player1?.name ?? "",
                    score: gameState.players.player1?.score ?? 0,
                    isActive: isPlayer1Turn
                )
                
                PlayerScoreView(
                    name: gameState.players.player2?.name ?? "",
                    score: gameState.players.player2?.score ?? 0,
                    isActive: !isPlayer1Turn
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
            
            // Current player indicator
            Text("\(isPlayer1Turn ? gameState.players.player1?.name ?? "" : gameState.players.player2?.name ?? "")'s turn")
                .font(.headline)
                .foregroundColor(.blue)
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
    
    private var gameOverView: some View {
        VStack(spacing: 20) {
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let winner = gameState.players.player1?.score == 3 ? gameState.players.player1 : gameState.players.player2 {
                Text("\(winner.name) wins!")
                    .font(.title)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(gameState.rounds) { round in
                    RoundSummaryView(round: round)
                }
            }
            .padding()
            
            Button("Play Again") {
                resetGame()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func startGame() {
        let player1 = Player(name: player1Name)
        let player2 = Player(name: player2Name)
        gameState.startNewGame(player1: player1, player2: player2)
        isPlayer1Turn = true
        startNextRound()
    }
    
    private func startNextRound() {
        gameState.currentQuestion = QuestionBank.getRandomQuestion()
        startTime = Date()
        selectedAnswer = nil
        isPlayer1Turn = true
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswer = index
        let time = Date().timeIntervalSince(startTime ?? Date())
        
        let currentPlayer = isPlayer1Turn ? gameState.players.player1 : gameState.players.player2
        
        if let player = currentPlayer {
            let isCorrect = index == gameState.currentQuestion?.correctAnswer
            let result = PlayerResult(
                playerId: player.id,
                answer: index,
                time: time,
                isCorrect: isCorrect
            )
            
            if isPlayer1Turn {
                gameState.player1Result = result
                isPlayer1Turn = false
            } else {
                gameState.player2Result = result
                
                if let player1Result = gameState.player1Result {
                    gameState.endRound(
                        player1Result: player1Result,
                        player2Result: result
                    )
                    showingResults = true
                }
            }
        }
    }
    
    private func resetGame() {
        gameState.reset()
        player1Name = ""
        player2Name = ""
        isPlayer1Turn = true
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
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSelected ? Color.blue : Color.gray)
                .cornerRadius(10)
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

struct RoundSummaryView: View {
    let round: RoundResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Round \(round.id)")
                .font(.headline)
            Text(round.question.text)
                .font(.subheadline)
            Text("Player 1: \(round.player1Result.isCorrect ? "✓" : "✗") \(String(format: "%.1f", round.player1Result.time))s")
            Text("Player 2: \(round.player2Result.isCorrect ? "✓" : "✗") \(String(format: "%.1f", round.player2Result.time))s")
        }
    }
}

#Preview {
    GameView()
} 
