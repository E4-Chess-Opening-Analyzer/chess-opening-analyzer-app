import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/services/move_to_pgn_service.dart';

abstract class GameboardState {
  GameboardState(
    this.gameBoard,
    this.moveToPgnService,
    this.pgn,
  );

  GameBoard gameBoard;
  MoveToPgnService moveToPgnService;
  String pgn = '';
}

class GameboardInitialState extends GameboardState {
  GameboardInitialState() : super(GameBoard(), MoveToPgnService(), '');
}

class GameboardUnselectedPieceState extends GameboardState {
  GameboardUnselectedPieceState(super.gameBoard, super.moveToPgnService, super.pgn) : super();
}

class GameboardSelectedPieceState extends GameboardState {
  GameboardSelectedPieceState(super.gameBoard, this.piece, super.moveToPgnService, super.pgn) : super();

  Piece piece;
}
