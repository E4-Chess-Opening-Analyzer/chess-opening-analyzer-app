import 'package:app/models/board/board_state.dart';
import 'package:app/models/move.dart';
import 'package:app/models/pieces/piece.dart';

mixin Pawn on Piece {
  @override
  List<(int, int)> getRawPossibleMoves(BoardState boardState) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    int direction = isDark() ? -1 : 1; // Dark pawns move down, light pawns move up

    // Move forward one square
    if (_isValidSquare(row + direction, column) && 
        boardState.getPieceAt(row + direction, column) == null) {
      possibleMoves.add((row + direction, column));

      // Move forward two squares from starting position
      if (!hasMoved && boardState.getPieceAt(row + 2 * direction, column) == null) {
        possibleMoves.add((row + 2 * direction, column));
      }
    }

    // Capture diagonally
    possibleMoves.addAll(_getDiagonalCaptures(boardState, direction));
    
    // En passant
    possibleMoves.addAll(_getEnPassantMoves(boardState, direction));

    return possibleMoves;
  }

  List<(int, int)> _getDiagonalCaptures(BoardState boardState, int direction) {
    List<(int, int)> captures = <(int, int)>[];
    
    // Left diagonal
    if (_isValidSquare(row + direction, column - 1)) {
      Piece? targetPiece = boardState.getPieceAt(row + direction, column - 1);
      if (targetPiece != null && targetPiece.isDark() != isDark()) {
        captures.add((row + direction, column - 1));
      }
    }
    
    // Right diagonal
    if (_isValidSquare(row + direction, column + 1)) {
      Piece? targetPiece = boardState.getPieceAt(row + direction, column + 1);
      if (targetPiece != null && targetPiece.isDark() != isDark()) {
        captures.add((row + direction, column + 1));
      }
    }
    
    return captures;
  }

  List<(int, int)> _getEnPassantMoves(BoardState boardState, int direction) {
    List<(int, int)> enPassantMoves = <(int, int)>[];
    
    if (boardState.moveHistory.isEmpty) {
      return enPassantMoves;
    }
    
    Move lastMove = boardState.moveHistory.last;
    
    // Check if last move was a pawn moving two squares
    if (lastMove.piece is! Pawn) {
      return enPassantMoves;
    }
    
    Pawn lastMovedPawn = lastMove.piece as Pawn;
    if (lastMovedPawn.isDark() == isDark()) {
      return enPassantMoves; // Same color
    }
    
    // Check if it was a two-square pawn move
    int expectedFromRow = isDark() ? 1 : 6; // Enemy pawn starting row
    int expectedToRow = isDark() ? 3 : 4;   // Enemy pawn after two-square move
    
    if (lastMove.fromRow == expectedFromRow && 
        lastMove.toRow == expectedToRow &&
        (lastMove.toRow == row) && // Same rank as our pawn
        (lastMove.toColumn == column - 1 || lastMove.toColumn == column + 1)) { // Adjacent column
      
      // En passant is possible
      enPassantMoves.add((row + direction, lastMove.toColumn));
    }
    
    return enPassantMoves;
  }

  bool _isValidSquare(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }
}
