import 'package:app/models/pieces/piece.dart';
import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/type/king.dart';

abstract class CheckDetector {
  bool isInCheck(bool lightKing, BoardState boardState);
  bool isCheckmate(bool lightKing, BoardState boardState);
  bool caseIsUnderAttack(int row, int column, bool byLight, BoardState boardState);
}

class StandardCheckDetector implements CheckDetector {
  @override
  bool isInCheck(bool lightKing, BoardState boardState) {
    Piece king = boardState.pieces.firstWhere(
      (Piece piece) => piece.isLight() == lightKing && piece is King,
    );
    return caseIsUnderAttack(king.row, king.column, !lightKing, boardState);
  }

  @override
  bool caseIsUnderAttack(int row, int column, bool byLight, BoardState boardState) {
    for (Piece piece in boardState.pieces) {
      if ((byLight && piece.isLight()) || (!byLight && piece.isDark())) {
        if (piece is King) {
          continue; // Avoid recursion
        }
        
        List<(int, int)> moves = piece.getRawPossibleMoves(boardState);
        if (moves.any(((int, int) move) => move == (row, column))) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  bool isCheckmate(bool lightKing, BoardState boardState) {
    if (!isInCheck(lightKing, boardState)) {
      return false;
    }

    for (Piece piece in boardState.pieces) {
      if (piece.isLight() == lightKing) {
        List<(int, int)> moves = piece.getRawPossibleMoves(boardState);
        if (moves.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }
}
