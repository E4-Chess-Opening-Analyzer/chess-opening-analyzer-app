import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';

abstract class GameboardState {
  GameboardState(
    this.gameBoard,
  );

  GameBoard gameBoard;
}

class GameboardInitialState extends GameboardState {
  GameboardInitialState() : super(GameBoard());
}

class GameboardUnselectedPieceState extends GameboardState {
  GameboardUnselectedPieceState(super.gameBoard) : super();
}

class GameboardSelectedPieceState extends GameboardState {
  GameboardSelectedPieceState(super.gameBoard, this.piece) : super();

  Piece piece;
}
