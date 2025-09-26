import 'package:app/models/piece.dart';
import 'package:app/enums/chess_piece_type.dart';

class GameBoard {
  final List<Piece> pieces = [];

  GameBoard() {
    _initializeBoard();
  }
  
  void _initializeBoard() {
    // Initialize light pieces
    pieces.addAll([
      Piece(type: ChessPieceType.lightRook, row: 0, column: 0),
      Piece(type: ChessPieceType.lightKnight, row: 0, column: 1),
      Piece(type: ChessPieceType.lightBishop, row: 0, column: 2),
      Piece(type: ChessPieceType.lightQueen, row: 0, column: 3),
      Piece(type: ChessPieceType.lightKing, row: 0, column: 4),
      Piece(type: ChessPieceType.lightBishop, row: 0, column: 5),
      Piece(type: ChessPieceType.lightKnight, row: 0, column: 6),
      Piece(type: ChessPieceType.lightRook, row: 0, column: 7),
    ]);
    for (int i = 0; i < 8; i++) {
      pieces.add(Piece(type: ChessPieceType.lightPawn, row: 1, column: i));
    }

    // Initialize dark pieces
    pieces.addAll([
      Piece(type: ChessPieceType.darkRook, row: 7, column: 0),
      Piece(type: ChessPieceType.darkKnight, row: 7, column: 1),
      Piece(type: ChessPieceType.darkBishop, row: 7, column: 2),
      Piece(type: ChessPieceType.darkQueen, row: 7, column: 3),
      Piece(type: ChessPieceType.darkKing, row: 7, column: 4),
      Piece(type: ChessPieceType.darkBishop, row: 7, column: 5),
      Piece(type: ChessPieceType.darkKnight, row: 7, column: 6),
      Piece(type: ChessPieceType.darkRook, row: 7, column: 7),
    ]);
    for (int i = 0; i < 8; i++) {
      pieces.add(Piece(type: ChessPieceType.darkPawn, row: 6, column: i));
    }
  }

  void movePiece(Piece piece, int newRow, int newColumn) {
    piece.row = newRow;
    piece.column = newColumn;
    piece.hasMoved = true;
  }

  Piece? getPieceAt(int row, int column) {
    Piece? foundPiece;
    for (var piece in pieces) {
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
}