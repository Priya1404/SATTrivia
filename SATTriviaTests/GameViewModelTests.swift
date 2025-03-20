//
//  GameViewModelTests.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import XCTest
@testable import SATTrivia

final class GameViewModelTests: XCTestCase {
    var viewModel: GameViewModel!
    var player1: Player!
    var player2: Player!
    
    override func setUp() {
        super.setUp()
        player1 = Player(name: "Player 1")
        player2 = Player(name: "Player 2")
        viewModel = GameViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        player1 = nil
        player2 = nil
        super.tearDown()
    }
    
    func testStartNewGame() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        XCTAssertEqual(viewModel.gameState.gameStatus, .inProgress)
        XCTAssertEqual(viewModel.gameState.currentRound, 1)
        XCTAssertEqual(viewModel.gameState.players.player1?.name, "Player 1")
        XCTAssertEqual(viewModel.gameState.players.player2?.name, "Player 2")
        XCTAssertEqual(viewModel.gameState.currentPlayerTurn, player1.id)
        XCTAssertNotNil(viewModel.gameState.currentQuestion)
    }
    
    func testEndPlayerTurn() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Player 1's turn
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        viewModel.endPlayerTurn(playerResult: player1Result)
        
        XCTAssertEqual(viewModel.gameState.currentPlayerTurn, player2.id)
        XCTAssertEqual(viewModel.gameState.players.player1?.score, 1)
        
        // Player 2's turn
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        viewModel.endPlayerTurn(playerResult: player2Result)
        
        XCTAssertEqual(viewModel.gameState.currentPlayerTurn, player1.id)
        XCTAssertEqual(viewModel.gameState.players.player2?.score, 0)
    }
    
    func testRoundTransition() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Complete first round
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        viewModel.endPlayerTurn(playerResult: player1Result)
        
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        viewModel.endPlayerTurn(playerResult: player2Result)
        
        XCTAssertEqual(viewModel.gameState.currentRound, 2)
        XCTAssertNotNil(viewModel.gameState.currentQuestion)
    }
    
    func testGameCompletion() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Complete 5 rounds
        for _ in 1...5 {
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            viewModel.endPlayerTurn(playerResult: player1Result)
            
            let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
            viewModel.endPlayerTurn(playerResult: player2Result)
        }
        
        XCTAssertEqual(viewModel.gameState.gameStatus, .finished)
    }
    
    func testResetGame() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Play some rounds
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        viewModel.endPlayerTurn(playerResult: player1Result)
        
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        viewModel.endPlayerTurn(playerResult: player2Result)
        
        // Reset game
        viewModel.reset()
        
        XCTAssertEqual(viewModel.gameState.gameStatus, .waiting)
        XCTAssertEqual(viewModel.gameState.currentRound, 1)
        XCTAssertNil(viewModel.gameState.players.player1)
        XCTAssertNil(viewModel.gameState.players.player2)
        XCTAssertNil(viewModel.gameState.currentQuestion)
        XCTAssertNil(viewModel.gameState.currentPlayerTurn)
        XCTAssertTrue(viewModel.gameState.rounds.isEmpty)
    }
    
    func testGameWinner() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Player 1 wins all rounds
        for _ in 1...5 {
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            viewModel.endPlayerTurn(playerResult: player1Result)
            
            let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
            viewModel.endPlayerTurn(playerResult: player2Result)
        }
        
        if let (winner, loser) = viewModel.gameState.getGameWinner() {
            XCTAssertEqual(winner?.id, player1.id)
            XCTAssertEqual(loser?.id, player2.id)
            XCTAssertEqual(winner?.score, 5)
            XCTAssertEqual(loser?.score, 0)
        } else {
            XCTFail("Game should have a winner")
        }
    }
    
    func testTiedGame() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Players tie all rounds
        for _ in 1...5 {
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            viewModel.endPlayerTurn(playerResult: player1Result)
            
            let player2Result = PlayerResult(playerId: player2.id, answer: 0, time: 6.0, isCorrect: true)
            viewModel.endPlayerTurn(playerResult: player2Result)
        }
        
        XCTAssertNil(viewModel.gameState.getGameWinner())
        XCTAssertEqual(viewModel.gameState.players.player1?.score, 5)
        XCTAssertEqual(viewModel.gameState.players.player2?.score, 5)
    }
    
    //MARK: To-Do: Fix the test
    /**
    func testRoundResultCreation() {
        viewModel.startNewGame(player1: player1, player2: player2)
        
        // Complete a round
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        viewModel.endPlayerTurn(playerResult: player1Result)
        
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        viewModel.endPlayerTurn(playerResult: player2Result)
        
        // Check round result
        XCTAssertEqual(viewModel.gameState.rounds.count, 1)
        let round = viewModel.gameState.rounds[0]
        XCTAssertEqual(round.player1Result?.playerId, player1.id)
        XCTAssertEqual(round.player2Result?.playerId, player2.id)
        XCTAssertEqual(round.winner, player1.id)
    }
    */
}
