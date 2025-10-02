import 'package:app/models/pieces/piece.dart';
import 'package:app/models/board/board_state.dart';
import 'package:app/services/check_detector.dart';

abstract class MoveValidator {
  bool isMoveLegal(Piece piece, int newRow, int newCol, BoardState boardState);
  List<(int, int)> filterLegalMoves(Piece piece, List<(int, int)> moves, BoardState boardState);
}

class StandardMoveValidator implements MoveValidator {
  StandardMoveValidator(this._checkDetector);

  final CheckDetector _checkDetector;

  @override
  bool isMoveLegal(Piece piece, int newRow, int newCol, BoardState boardState) {
    // Save current state
    int originalRow = piece.row;
    int originalCol = piece.column;
    Piece? capturedPiece = boardState.getPieceAt(newRow, newCol);
    
    // Make move temporarily
    piece.row = newRow;
    piece.column = newCol;
    if (capturedPiece != null) {
      boardState.removePiece(capturedPiece);
    }
    
    // Check if king would be in check
    bool isLegal = !_checkDetector.isInCheck(piece.isLight(), boardState);
    
    // Restore state
    piece.row = originalRow;
    piece.column = originalCol;
    if (capturedPiece != null) {
      boardState.addPiece(capturedPiece);
    }
    
    return isLegal;
  }

  @override
  List<(int, int)> filterLegalMoves(Piece piece, List<(int, int)> moves, BoardState boardState) {
    return moves.where(((int, int) move) => isMoveLegal(piece, move.$1, move.$2, boardState)).toList();
  }
}
