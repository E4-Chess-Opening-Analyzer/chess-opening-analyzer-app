

import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/king.dart';
import 'package:app/services/special_move_handlers.dart';

class CastlingHandler implements SpecialMoveHandler {
  @override
  void handle(Piece piece, int newRow, int newColumn, BoardState boardState) {
    if (piece is! King || piece.hasMoved) {
      return;
    }

    if (piece.isLight() && newRow == 0) {
      if (newColumn == 6) {
        Piece? rook = boardState.getPieceAt(0, 7);
        if (rook != null && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2) {
        Piece? rook = boardState.getPieceAt(0, 0);
        if (rook != null && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 3;
          rook.hasMoved = true;
        }
      }
    } else if (!piece.isLight() && newRow == 7) {
      if (newColumn == 6) {
        Piece? rook = boardState.getPieceAt(7, 7);
        if (rook != null && !rook.hasMoved) {
          rook.row = 7;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2) {
        Piece? rook = boardState.getPieceAt(7, 0);
        if (rook != null && !rook.hasMoved) {
          rook.row = 7;
          rook.column = 3;
          rook.hasMoved = true;
        }
      }
    }
  }
}
