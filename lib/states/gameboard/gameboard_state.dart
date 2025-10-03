import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/services/move_to_pgn_service.dart';

abstract class GameboardState {
  GameboardState(
    this.gameBoard,
    this.moveToPgnService,
  );

  GameBoard gameBoard;
  MoveToPgnService moveToPgnService;
}

class GameboardInitialState extends GameboardState {
  GameboardInitialState() : super(GameBoard(), MoveToPgnService());
}

class GameboardUnselectedPieceState extends GameboardState {
  GameboardUnselectedPieceState(super.gameBoard, super.moveToPgnService) : super();
}

class GameboardSelectedPieceState extends GameboardState {
  GameboardSelectedPieceState(super.gameBoard, this.piece, super.moveToPgnService) : super();

  Piece piece;
}
