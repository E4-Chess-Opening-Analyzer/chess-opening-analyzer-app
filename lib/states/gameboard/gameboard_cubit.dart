import 'package:app/models/pieces/piece.dart';
import 'package:app/states/gameboard/gameboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameboardCubit extends Cubit<GameboardState> {
  GameboardCubit() : super(GameboardInitialState());

  void selectPiece(Piece piece) {
    emit(GameboardSelectedPieceState(state.gameBoard, piece));
  }

  void unselectPiece() {
    emit(GameboardUnselectedPieceState(state.gameBoard));
  }

  void moveSelectedPieceTo(int row, int column) {
    if (state is GameboardSelectedPieceState) {
      final GameboardSelectedPieceState selectedState = state as GameboardSelectedPieceState;
      final Piece piece = selectedState.piece;

      // Check if the move is valid
      final List<(int, int)> possibleMoves = piece.getPossibleMoves(state.gameBoard);
      if (possibleMoves.any(((int, int) move) => move == (row, column))) {
        // Move the piece
        state.gameBoard.movePiece(piece, row, column);

        // Update the game board state
        emit(GameboardUnselectedPieceState(state.gameBoard));
      } else {
        // Invalid move, just unselect the piece
        emit(GameboardUnselectedPieceState(state.gameBoard));
      }
    }
  }
}
