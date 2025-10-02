import 'package:app/models/pieces/piece.dart';
import 'package:app/models/board/board_state.dart';


abstract class SpecialMoveHandler {
  void handle(Piece piece, int newRow, int newColumn, BoardState boardState);
}
