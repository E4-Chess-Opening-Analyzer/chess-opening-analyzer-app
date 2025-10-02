import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/dark/dark_pawn.dart';
import 'package:app/models/pieces/light/light_pawn.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/services/special_move_handlers.dart';

class EnPassantHandler implements SpecialMoveHandler {
  @override
  void handle(Piece piece, int newRow, int newColumn, BoardState boardState) {
    if (piece is LightPawn 
      && piece.row == 4 && newRow == 5 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = boardState.getPieceAt(4, newColumn);
      if (enPassantTarget != null && enPassantTarget is DarkPawn) {
        boardState.removePiece(enPassantTarget);
      }
    } else if (piece is DarkPawn 
      && piece.row == 3 && newRow == 2 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = boardState.getPieceAt(3, newColumn);
      if (enPassantTarget != null && enPassantTarget is LightPawn) {
        boardState.removePiece(enPassantTarget);
      }
    }

  }
}
