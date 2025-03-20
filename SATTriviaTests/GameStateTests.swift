//
//  GameStateTests.swift
//  SATTrivia
//
//  Created by Priya Srivastava on 19/03/25.
//

import XCTest
@testable import SATTrivia

final class GameStateTests: XCTestCase {
    var gameState: GameState!
    var player1: Player!
    var player2: Player!
    
    override func setUp() {
        super.setUp()
        player1 = Player(name: "Player 1")
        player2 = Player(name: "Player 2")
        gameState = GameState()
    }
    
    override func tearDown() {
        gameState = nil
        player1 = nil
        player2 = nil
        super.tearDown()
    }
    
    func testGameInitialization() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        XCTAssertEqual(gameState.gameStatus, .inProgress)
        XCTAssertEqual(gameState.currentRound, 1)
        XCTAssertEqual(gameState.players.player1?.name, "Player 1")
        XCTAssertEqual(gameState.players.player2?.name, "Player 2")
        XCTAssertEqual(gameState.players.player1?.score, 0)
        XCTAssertEqual(gameState.players.player2?.score, 0)
        XCTAssertEqual(gameState.currentPlayerTurn, player1.id)
        XCTAssertNotNil(gameState.currentQuestion)
    }
    
    func testPlayerTurnTransition() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // First player's turn
        XCTAssertEqual(gameState.currentPlayerTurn, player1.id)
        
        // End first player's turn
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        gameState.endPlayerTurn(playerResult: player1Result)
        
        // Should be second player's turn
        XCTAssertEqual(gameState.currentPlayerTurn, player2.id)
        
        // End second player's turn
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        gameState.endPlayerTurn(playerResult: player2Result)
        
        // Should be first player's turn again
        XCTAssertEqual(gameState.currentPlayerTurn, player1.id)
    }
    //MARK: To-Do: Fix the test
    /**
    func testScoring() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // Player 1 correct answer
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        gameState.endPlayerTurn(playerResult: player1Result)
        XCTAssertEqual(gameState.players.player1?.score, 1)
        XCTAssertEqual(gameState.players.player2?.score, 0)
        
        // Player 2 incorrect answer
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        gameState.endPlayerTurn(playerResult: player2Result)
        XCTAssertEqual(gameState.players.player1?.score, 1)
        XCTAssertEqual(gameState.players.player2?.score, 0)
    }
    */
    
    func testRoundManagement() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // First round
        XCTAssertEqual(gameState.currentRound, 1)
        
        // Complete first round
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        gameState.endPlayerTurn(playerResult: player1Result)
        
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        gameState.endPlayerTurn(playerResult: player2Result)
        
        // Should be second round
        XCTAssertEqual(gameState.currentRound, 2)
        XCTAssertNotNil(gameState.currentQuestion)
    }
    
    //MARK: To-Do: Fix the test
    /**
    func testGameCompletion() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // Complete 5 rounds
        for round in 1...5 {
            XCTAssertEqual(gameState.currentRound, round)
            
            // Player 1's turn
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            gameState.endPlayerTurn(playerResult: player1Result)
            
            // Player 2's turn
            let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
            gameState.endPlayerTurn(playerResult: player2Result)
        }
        
        // Game should be finished
        XCTAssertEqual(gameState.gameStatus, .finished)
    }
     */
    
    func testGameReset() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // Play some rounds
        let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
        gameState.endPlayerTurn(playerResult: player1Result)
        
        let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
        gameState.endPlayerTurn(playerResult: player2Result)
        
        // Reset game
        gameState.reset()
        
        // Check reset state
        XCTAssertEqual(gameState.gameStatus, .waiting)
        XCTAssertEqual(gameState.currentRound, 1)
        XCTAssertNil(gameState.players.player1)
        XCTAssertNil(gameState.players.player2)
        XCTAssertNil(gameState.currentQuestion)
        XCTAssertNil(gameState.currentPlayerTurn)
        XCTAssertTrue(gameState.rounds.isEmpty)
    }
    
    func testGameWinner() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // Player 1 wins all rounds
        for _ in 1...5 {
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            gameState.endPlayerTurn(playerResult: player1Result)
            
            let player2Result = PlayerResult(playerId: player2.id, answer: 1, time: 6.0, isCorrect: false)
            gameState.endPlayerTurn(playerResult: player2Result)
        }
        
        // Check winner
        if let (winner, loser) = gameState.getGameWinner() {
            XCTAssertEqual(winner?.id, player1.id)
            XCTAssertEqual(loser?.id, player2.id)
            XCTAssertEqual(winner?.score, 5)
            XCTAssertEqual(loser?.score, 0)
        } else {
            XCTFail("Game should have a winner")
        }
    }
    
    func testTiedGame() {
        gameState.startNewGame(player1: player1, player2: player2)
        
        // Players tie all rounds
        for _ in 1...5 {
            let player1Result = PlayerResult(playerId: player1.id, answer: 0, time: 5.0, isCorrect: true)
            gameState.endPlayerTurn(playerResult: player1Result)
            
            let player2Result = PlayerResult(playerId: player2.id, answer: 0, time: 6.0, isCorrect: true)
            gameState.endPlayerTurn(playerResult: player2Result)
        }
        
        // Check for tie
        XCTAssertNil(gameState.getGameWinner())
        XCTAssertEqual(gameState.players.player1?.score, 5)
        XCTAssertEqual(gameState.players.player2?.score, 5)
    }
} 
