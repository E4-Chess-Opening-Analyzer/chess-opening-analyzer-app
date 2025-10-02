import 'package:app/models/board/board_state.dart';
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

abstract class BoardInitializer {
  void initialize(BoardState boardState);
}

class StandardBoardInitializer implements BoardInitializer {
  @override
  void initialize(BoardState boardState) {
    _initializeLightPieces(boardState);
    _initializeDarkPieces(boardState);
  }

  void _initializeLightPieces(BoardState boardState) {
    boardState.addPiece(LightKing(row: 0, column: 4, hasMoved: false));
    boardState.addPiece(LightQueen(row: 0, column: 3, hasMoved: false));
    boardState.addPiece(LightRook(row: 0, column: 0, hasMoved: false));
    boardState.addPiece(LightRook(row: 0, column: 7, hasMoved: false));
    boardState.addPiece(LightBishop(row: 0, column: 2, hasMoved: false));
    boardState.addPiece(LightBishop(row: 0, column: 5, hasMoved: false));
    boardState.addPiece(LightKnight(row: 0, column: 1, hasMoved: false));
    boardState.addPiece(LightKnight(row: 0, column: 6, hasMoved: false));

    for (int i = 0; i < 8; i++) {
      boardState.addPiece(LightPawn(row: 1, column: i, hasMoved: false));
    }
  }

  void _initializeDarkPieces(BoardState boardState) {
    boardState.addPiece(DarkKing(row: 7, column: 4, hasMoved: false));
    boardState.addPiece(DarkQueen(row: 7, column: 3, hasMoved: false));
    boardState.addPiece(DarkRook(row: 7, column: 0, hasMoved: false));
    boardState.addPiece(DarkRook(row: 7, column: 7, hasMoved: false));
    boardState.addPiece(DarkBishop(row: 7, column: 2, hasMoved: false));
    boardState.addPiece(DarkBishop(row: 7, column: 5, hasMoved: false));
    boardState.addPiece(DarkKnight(row: 7, column: 1, hasMoved: false));
    boardState.addPiece(DarkKnight(row: 7, column: 6, hasMoved: false));

    for (int i = 0; i < 8; i++) {
      boardState.addPiece(DarkPawn(row: 6, column: i, hasMoved: false));
    }
  }
}
