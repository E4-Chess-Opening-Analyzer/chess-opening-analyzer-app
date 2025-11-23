# Chess Opening Analyzer

A Flutter application that provides real-time analysis and statistics for chess opening moves, helping players understand the effectiveness of different opening strategies through data-driven insights.

## 📱 Features

- **Interactive Chess Board**: Visual chess board with piece movement and complete game state management
- **Opening Analysis**: Real-time statistics on chess opening moves including win/draw/loss probabilities
- **Move Validation**: Complete chess rule validation including special moves (castling, en passant)
- **Game History**: Track and analyze your game progression with PGN notation
- **Statistical Insights**: Data-driven opening recommendations based on extensive game databases

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **SOLID** design patterns:

### Core Components
- **Models** - Game state, pieces, moves, and board representation
- **Services** - Chess logic, move validation, API integration
- **State Management** - BLoC pattern for reactive state management
- **Views** - Atomic design pattern for UI components

### Key Design Patterns
- **Strategy Pattern**: Different piece movement strategies
- **Command Pattern**: Move execution and history tracking
- **Facade Pattern**: GameBoard as simplified interface
- **Mixin Pattern**: Piece composition (Light/Dark + Piece Types)

## 🎮 How It Works

1. **Game Setup**: Initialize standard chess board with proper piece placement
2. **Move Input**: Click pieces to see available moves with visual indicators
3. **Real-time Analysis**: After each move, get statistical analysis from chess databases
4. **Opening Insights**: View win/draw/loss percentages for different opening continuations

## 🛠️ Tech Stack

- **Flutter 3.9.2+** - Cross-platform UI framework
- **BLoC 9.1.1** - Predictable state management
- **HTTP 1.6.0** - API communication for chess statistics
- **Chess 0.8.1** - Chess logic and validation
- **Provider 6.1.5** - Dependency injection

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- iOS Simulator/Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:E4-Chess-Opening-Analyzer/chess-opening-analyzer-app.git
   cd chess-opening-analyzer-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons (optional)**
   ```bash
   dart run flutter_launcher_icons
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── models/          # Data models and game logic
├── services/        # Business logic and API services
├── states/          # BLoC state management
├── views/           # UI components (Atomic Design)
│   ├── atoms/       # Basic UI components
│   ├── molecules/   # Composite components
│   ├── organisms/   # Complex UI sections
│   └── pages/       # Full page layouts
└── main.dart        # App entry point
```

## 📡 API Integration

The app integrates with chess databases to provide:
- Opening move statistics
- Win/loss/draw percentages
- Game frequency data

## 🎨 Custom Fonts

The app uses custom typography:
- **Ibarra Real Nova** - Main headings and titles
- **Inria Sans** - Body text and UI elements

## 📚 Development

### Code Analysis
```bash
flutter analyze
```

### Building for Release
```bash
# Android
flutter build apk

# iOS
flutter build ios
```
