import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/rook.dart';

mixin King on Piece {
  @override
  List<(int, int)> getRawPossibleMoves(BoardState boardState) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    // For raw moves, don't check safety - just return all possible squares
    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = boardState.getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.isDark() != isDark()) {
          possibleMoves.add((newRow, newCol));
        }
      }
    }

    return possibleMoves;
  }

  // Separate method for getting legal moves (with safety checks)
  List<(int, int)> getLegalMoves(BoardState boardState) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = boardState.getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.isDark() != isDark()) {
          // Check if the move would be safe
          if (_wouldMoveBeSafe(newRow, newCol, boardState)) {
            possibleMoves.add((newRow, newCol));
          }
        }
      }
    }

    // Add castling moves
    possibleMoves.addAll(_getCastlingMoves(boardState));

    return possibleMoves;
  }

  List<(int, int)> _getCastlingMoves(BoardState boardState) {
    List<(int, int)> castlingMoves = <(int, int)>[];
    
    if (hasMoved) {
      return castlingMoves;
    }
    if (_isCurrentlyInCheck(boardState)) {
      return castlingMoves;
    }

    // Kingside castling
    Piece? kingsideRook = boardState.getPieceAt(row, 7);
    if (kingsideRook != null && 
        kingsideRook is Rook && 
        kingsideRook.isLight() == isLight() && 
        !kingsideRook.hasMoved) {
      
      if (boardState.getPieceAt(row, 5) == null && 
          boardState.getPieceAt(row, 6) == null) {
        
        if (_wouldMoveBeSafe(row, 5, boardState) && 
            _wouldMoveBeSafe(row, 6, boardState)) {
          castlingMoves.add((row, 6));
        }
      }
    }

    // Queenside castling
    Piece? queensideRook = boardState.getPieceAt(row, 0);
    if (queensideRook != null && 
        queensideRook is Rook && 
        queensideRook.isLight() == isLight() && 
        !queensideRook.hasMoved) {
      
      if (boardState.getPieceAt(row, 1) == null && 
          boardState.getPieceAt(row, 2) == null && 
          boardState.getPieceAt(row, 3) == null) {
        
        if (_wouldMoveBeSafe(row, 2, boardState) && 
            _wouldMoveBeSafe(row, 3, boardState)) {
          castlingMoves.add((row, 2));
        }
      }
    }

    return castlingMoves;
  }

  bool _wouldMoveBeSafe(int newRow, int newCol, BoardState boardState) {
    int originalRow = row;
    int originalCol = column;
    Piece? capturedPiece = boardState.getPieceAt(newRow, newCol);
    
    row = newRow;
    column = newCol;
    if (capturedPiece != null) {
      boardState.pieces.remove(capturedPiece);
    }
    
    // Use simplified attack check to avoid recursion
    bool isSafe = !_isSquareUnderAttackSimple(newRow, newCol, boardState);
    
    row = originalRow;
    column = originalCol;
    if (capturedPiece != null) {
      boardState.pieces.add(capturedPiece);
    }
    
    return isSafe;
  }

  bool _isCurrentlyInCheck(BoardState boardState) {
    return _isSquareUnderAttackSimple(row, column, boardState);
  }

  // Simplified attack check that avoids king recursion
  bool _isSquareUnderAttackSimple(int targetRow, int targetCol, BoardState boardState) {
    for (Piece piece in boardState.pieces) {
      if (piece.isDark() != isDark() && piece != this) {
        if (piece is King) {
          // For enemy kings, check only basic moves (no safety checks)
          List<(int, int)> kingMoves = <(int, int)>[
            (1, 0), (-1, 0), (0, 1), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1)
          ];
          
          for (var (int dRow, int dCol) in kingMoves) {
            int newRow = piece.row + dRow;
            int newCol = piece.column + dCol;
            if (newRow == targetRow && newCol == targetCol) {
              return true;
            }
          }
        } else {
          // For other pieces, use their raw moves
          List<(int, int)> attackMoves = piece.getRawPossibleMoves(boardState);
          if (attackMoves.any(((int, int) move) => move == (targetRow, targetCol))) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
