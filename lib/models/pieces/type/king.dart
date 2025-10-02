import 'package:app/models/pieces/piece.dart';
import 'package:app/models/game_board.dart';
import 'package:app/models/pieces/type/rook.dart';

mixin King on Piece {
  @override
  List<(int, int)> getPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = gameBoard.getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.isDark() != isDark()) {
          // Temporarily simulate the move to check if the square would be safe
          if (_isKingMoveSafe(newRow, newCol, gameBoard)) {
            possibleMoves.add((newRow, newCol));
          }
        }
      }
    }

    // Castling - only if not in check and path is clear
    if (!hasMoved && !gameBoard.isInCheck(true)) {
      // Kingside castling
      Piece? rook = gameBoard.getPieceAt(row, 7);
      if (rook != null && rook.isLight() && rook is Rook && !rook.hasMoved) {
        if (gameBoard.getPieceAt(row, 5) == null && gameBoard.getPieceAt(row, 6) == null
          && !gameBoard.caseIsUnderAttack(row, 4, false)
          && !gameBoard.caseIsUnderAttack(row, 5, false)
          && !gameBoard.caseIsUnderAttack(row, 6, false)
        ) {
          possibleMoves.add((row, 6));
        }
      }
      // Queenside castling
      rook = gameBoard.getPieceAt(row, 0);
      if (rook != null && rook.isLight() && rook is Rook && !rook.hasMoved) {
        if (gameBoard.getPieceAt(row, 1) == null && gameBoard.getPieceAt(row, 2) == null && gameBoard.getPieceAt(row, 3) == null
          && !gameBoard.caseIsUnderAttack(row, 4, false)
          && !gameBoard.caseIsUnderAttack(row, 3, false)
          && !gameBoard.caseIsUnderAttack(row, 2, false)
        ) {
          possibleMoves.add((row, 2));
        }
      }
    }

    return possibleMoves;
  }

  @override
  List<(int, int)> getRawPossibleMoves(GameBoard gameBoard) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = row + dRow;
      int newCol = column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        possibleMoves.add((newRow, newCol));
      }
    }

    return possibleMoves;
  }
  
  // New helper method to check if a king move is safe
  bool _isKingMoveSafe(int newRow, int newCol, GameBoard gameBoard) {
    // Save the current state
    int originalRow = row;
    int originalCol = column;
    Piece? capturedPiece = gameBoard.getPieceAt(newRow, newCol);
    
    // Temporarily make the move
    row = newRow;
    column = newCol;
    if (capturedPiece != null) {
      gameBoard.pieces.remove(capturedPiece);
    }
    
    // Check if the king would be under attack at the new position
    bool isSafe = !gameBoard.caseIsUnderAttack(newRow, newCol, isDark());
    
    // Restore the original state
    row = originalRow;
    column = originalCol;
    if (capturedPiece != null) {
      gameBoard.pieces.add(capturedPiece);
    }
    
    return isSafe;
  }
}
