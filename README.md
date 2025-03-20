# SAT Trivia Game

A fun and educational iOS game that tests your SAT knowledge through an engaging two-player trivia experience.

## Features

- Two-player competitive gameplay
- SAT-style questions covering various subjects
- Real-time scoring and round tracking
- Detailed round results and game history
- Beautiful, modern SwiftUI interface

## Game Rules

1. Two players compete in a best-of-3 rounds format
2. Each round consists of:
   - Both players receive the same question
   - Players have a time limit to answer
   - Points are awarded for correct answers
   - Round winner is determined by correctness and speed
3. The game ends after 3 rounds
4. The player with the highest score wins
5. In case of a tie, the game is declared a draw

## Technical Details

- Built with SwiftUI for iOS
- Uses MVVM architecture
- Implements unit tests for game logic
- Supports iOS 15.0 and later

## Project Structure

```
SATTrivia/
├── Models/
│   └── GameModels.swift      # Core game data models and logic
├── ViewModels/
│   └── GameViewModel.swift   # Game state management
├── Views/
│   ├── GameView.swift        # Main game interface
│   ├── GameOverView.swift    # End game screen
│   └── PlayerRoundResultRow.swift  # Round result display
├── Extensions/
│   └── Color+Extensions.swift # Custom color extensions
├── Assets.xcassets/          # Game assets and resources
├── Preview Content/          # SwiftUI preview assets
└── SATTriviaApp.swift        # App entry point

SATTriviaTests/               # Unit tests for game logic
└── GameStateTests.swift      # Tests for game state management
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository
2. Open `SATTrivia.xcodeproj` in Xcode
3. Build and run the project

## Testing

The project includes unit tests for:
- Game state management
- Player turn transitions
- Score calculations
- Round management
- Game completion logic

Run tests using Cmd+U in Xcode or through the Test Navigator.
