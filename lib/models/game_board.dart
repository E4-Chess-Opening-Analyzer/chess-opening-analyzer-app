import 'package:app/models/move.dart';
import 'package:app/models/pieces/dark/dark_bishop.dart';
import 'package:app/models/pieces/dark/dark_king.dart';
import 'package:app/models/pieces/dark/dark_knight.dart';
import 'package:app/models/pieces/dark/dark_pawn.dart';
import 'package:app/models/pieces/dark/dark_queen.dart';
import 'package:app/models/pieces/dark/dark_rook.dart';
import 'package:app/models/pieces/light/light_bishop.dart';
import 'package:app/models/pieces/light/light_king.dart';
import 'package:app/models/pieces/light/light_knight.dart';
import 'package:app/models/pieces/light/light_pawn.dart';
import 'package:app/models/pieces/light/light_queen.dart';
import 'package:app/models/pieces/light/light_rook.dart';
import 'package:app/models/pieces/type/king.dart';
import 'package:app/models/pieces/piece.dart';

class GameBoard {
  GameBoard() {
    _initializeBoard();
  }

  final List<Piece> pieces = <Piece>[];
  final List<Move> moveHistory = <Move>[];
  
  void _initializeBoard() {
    // Initialize light pieces
    pieces.addAll(<Piece>[
      LightKing(row: 0, column: 4, hasMoved: false),
      LightQueen(row: 0, column: 3, hasMoved: false),
      LightRook(row: 0, column: 0, hasMoved: false),
      LightRook(row: 0, column: 7, hasMoved: false),
      LightBishop(row: 0, column: 2, hasMoved: false),
      LightBishop(row: 0, column: 5, hasMoved: false),
      LightKnight(row: 0, column: 1, hasMoved: false),
      LightKnight(row: 0, column: 6, hasMoved: false),
    ]);
    for (int i = 0; i < 8; i++) {
      pieces.add(LightPawn(row: 1, column: i, hasMoved: false));
    }

    // Initialize dark pieces
    pieces.addAll(<Piece>[
      DarkKing(row: 7, column: 4, hasMoved: false),
      DarkQueen(row: 7, column: 3, hasMoved: false),
      DarkRook(row: 7, column: 0, hasMoved: false),
      DarkRook(row: 7, column: 7, hasMoved: false),
      DarkBishop(row: 7, column: 2, hasMoved: false),
      DarkBishop(row: 7, column: 5, hasMoved: false),
      DarkKnight(row: 7, column: 1, hasMoved: false),
      DarkKnight(row: 7, column: 6, hasMoved: false),
    ]);
    for (int i = 0; i < 8; i++) {
      pieces.add(DarkPawn(row: 6, column: i, hasMoved: false));
    }
  }

  bool isLightPieceTurn() {
    return moveHistory.length % 2 == 0;
  }

  bool isDarkPieceTurn() {
    return moveHistory.length % 2 == 1;
  }

  bool isCheckmate(bool lightKing) {
    // Check if the king is in check
    if (!isInCheck(lightKing)) {
      return false;
    }

    // Check if the king has any legal moves
    Piece king = pieces.firstWhere(
      (Piece piece) => piece.isLight() == lightKing && piece is King,
    );
    List<(int, int)> kingMoves = king.getPossibleMoves(this);
    if (kingMoves.isNotEmpty) {
      return false;
    }

    // Check if any other piece can block the check or capture the attacking piece
    for (Piece piece in pieces) {
      if (piece.isLight() == lightKing && piece is! King) {
        List<(int, int)> moves = piece.getPossibleMoves(this);
        if (moves.isNotEmpty) {
          return false;
        }
      }
    }

    return true; // No legal moves available, it's checkmate
  }

  void movePiece(Piece piece, int newRow, int newColumn) {
    // Capture any piece at the new position
    Piece? targetPiece = getPieceAt(newRow, newColumn);
    
    if (targetPiece != null && targetPiece != piece) {
      removePiece(targetPiece);
    }

    // En passant capture
    if (piece is LightPawn 
      && piece.row == 4 && newRow == 5 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = getPieceAt(4, newColumn);
      if (enPassantTarget != null && enPassantTarget is DarkPawn) {
        removePiece(enPassantTarget);
      }
    } else if (piece is DarkPawn 
      && piece.row == 3 && newRow == 2 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = getPieceAt(3, newColumn);
      if (enPassantTarget != null && enPassantTarget is LightPawn) {
        removePiece(enPassantTarget);
      }
    }

    // Castling
    if (piece is LightKing && !piece.hasMoved) {
      if (newColumn == 6 && newRow == 0) { // Kingside
        Piece? rook = getPieceAt(0, 7);
        if (rook != null && rook is LightRook && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2 && newRow == 0) { // Queenside
        Piece? rook = getPieceAt(0, 0);
        if (rook != null && rook is LightRook && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 3;
          rook.hasMoved = true;
        }
      }
    } else if (piece is DarkKing && !piece.hasMoved) {
      if (newColumn == 6 && newRow == 7) { // Kingside
        Piece? rook = getPieceAt(7, 7);
        if (rook != null && rook is DarkRook && !rook.hasMoved) {
          rook.row = 7;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2 && newRow == 7) { // Queenside
        Piece? rook = getPieceAt(7, 0);
        if (rook != null && rook is DarkRook && !rook.hasMoved) {
          rook.row = 7;
          rook.column = 3;
          rook.hasMoved = true;
        }
      }
    }

    // Record the move
    moveHistory.add(Move(
      fromRow: piece.row,
      fromColumn: piece.column,
      toRow: newRow,
      toColumn: newColumn,
      piece: piece,
      capturedPiece: targetPiece,
    ));
    
    piece.row = newRow;
    piece.column = newColumn;
    piece.hasMoved = true;
  }

  Piece? getPieceAt(int row, int column) {
    Piece? foundPiece;
    for (Piece piece in pieces) {
      if (piece.row == row && piece.column == column) {
        foundPiece = piece;
        break;
      }
    }
    return foundPiece;
  }

  void removePiece(Piece piece) {
    pieces.remove(piece);
  }

  void removePieceAt(int row, int column) {
    removePiece(getPieceAt(row, column)!);
  }

  List<(int, int)> filterMovesForCheck(Piece piece, List<(int, int)> moves) {
    List<(int, int)> legalMoves = <(int, int)>[];
    
    for (var (int dRow, int dCol) in moves) {
      if (_isMoveLegal(piece, dRow, dCol)) {
        legalMoves.add((dRow, dCol));
      }
    }
    
    return legalMoves;
  }

  bool _isMoveLegal(Piece piece, int newRow, int newCol) {
    // Save the current state
    int originalRow = piece.row;
    int originalCol = piece.column;
    Piece? capturedPiece = getPieceAt(newRow, newCol);
    
    // Make the move temporarily
    piece.row = newRow;
    piece.column = newCol;
    if (capturedPiece != null) {
      pieces.remove(capturedPiece);
    }
    
    // Check if our king is in check after this move
    bool isLegal = !isInCheck(piece.isLight());
    
    // Restore the original state
    piece.row = originalRow;
    piece.column = originalCol;
    if (capturedPiece != null) {
      pieces.add(capturedPiece);
    }
    
    return isLegal;
  }

  bool caseIsUnderAttack(int row, int column, bool byLight, {bool ignoreKings = false}) {
    for (Piece piece in pieces) {
      if ((byLight && piece.isLight()) ||
          (!byLight && piece.isDark())) {
        
        // Skip kings to avoid infinite recursion during legal move calculation
        if (ignoreKings && piece is King) {
          continue;
        }
        
        // For attack calculations, use raw moves without check filtering
        List<(int, int)> possibleMoves = piece.getRawPossibleMoves(this);
        if (possibleMoves.any(((int, int) move) => move == (row, column))) {
          return true;
        }
      }
    }
    return false;
  }

  bool isInCheck(bool lightKing) {
    Piece king = pieces.firstWhere(
      (Piece piece) => piece.isLight() == lightKing && piece is King,
    );
    return caseIsUnderAttack(king.row, king.column, !lightKing);
  }
}
