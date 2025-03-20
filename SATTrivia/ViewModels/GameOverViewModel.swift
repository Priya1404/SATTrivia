import SwiftUI

class GameOverViewModel: ObservableObject {
    @Published var showConfetti = false
    @Published var showLogs = false
    @Published var showWinnerGif = false
    @Published var showLoserGif = false
    
    let winner: Player
    let loser: Player
    let rounds: [RoundResult]
    let isTie: Bool
    
    init(winner: Player, loser: Player, rounds: [RoundResult], isTie: Bool = false) {
        self.winner = winner
        self.loser = loser
        self.rounds = rounds
        self.isTie = isTie
    }
    
    func toggleLogs() {
        showLogs.toggle()
    }
    
    func toggleWinnerGif() {
        withAnimation {
            showWinnerGif.toggle()
        }
    }
    
    func toggleLoserGif() {
        withAnimation {
            showLoserGif.toggle()
        }
    }
    
    func getRoundWinner(round: RoundResult) -> String? {
        guard let winnerId = round.winner else { return nil }
        return winnerId == round.player1Result?.playerId ? winner.name : loser.name
    }
    
    func isRoundTied(round: RoundResult) -> Bool {
        return round.winner == nil
    }
} 