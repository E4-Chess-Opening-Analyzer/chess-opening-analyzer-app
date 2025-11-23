import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/services/move_to_pgn_service.dart';
import 'package:app/states/gameboard/gameboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameboardCubit extends Cubit<GameboardState> {
  GameboardCubit() : super(GameboardInitialState());

  void selectPiece(Piece piece) {
    emit(GameboardSelectedPieceState(state.gameBoard, piece, state.moveToPgnService, state.pgn));
  }

  void unselectPiece() {
    emit(GameboardUnselectedPieceState(state.gameBoard, state.moveToPgnService, state.pgn));
  }

  String moveSelectedPieceTo(int row, int column) {
    if (state is GameboardSelectedPieceState) {
      final GameboardSelectedPieceState selectedState = state as GameboardSelectedPieceState;
      final Piece piece = selectedState.piece;

      // Check if the move is valid
      final List<(int, int)> possibleMoves = state.gameBoard.getPossibleMoves(piece);
      if (possibleMoves.any(((int, int) move) => move == (row, column))) {
        String pgn = state.moveToPgnService.getPgnFromMove(
          piece.row,
          piece.column,
          row,
          column,
        );

        // Move the piece
        state.gameBoard.movePiece(piece, row, column);

        // Update the game board state
        emit(GameboardUnselectedPieceState(state.gameBoard, state.moveToPgnService, pgn));
        return pgn;
      } else {
        // Invalid move, just unselect the piece
        emit(GameboardUnselectedPieceState(state.gameBoard, state.moveToPgnService, state.pgn));
      }
    }
    return state.pgn;
  }

  void resetGame() {
    emit(GameboardUnselectedPieceState(GameBoard(), MoveToPgnService(), ''));
  }
}
