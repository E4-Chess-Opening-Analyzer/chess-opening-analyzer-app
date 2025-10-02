import 'package:app/models/pieces/piece.dart';
import 'package:app/models/board/board_state.dart';
import 'package:app/models/move.dart';
import 'package:app/services/special_move_handlers.dart';

abstract class MoveExecutor {
  void executeMove(Piece piece, int newRow, int newColumn, BoardState boardState);
}

class StandardMoveExecutor implements MoveExecutor {
  StandardMoveExecutor(this._specialMoveHandlers);

  final List<SpecialMoveHandler> _specialMoveHandlers;

  @override
  void executeMove(Piece piece, int newRow, int newColumn, BoardState boardState) {
    Piece? targetPiece = boardState.getPieceAt(newRow, newColumn);
    
    // Handle captures
    if (targetPiece != null && targetPiece != piece) {
      boardState.removePiece(targetPiece);
    }

    // Handle special moves
    for (SpecialMoveHandler handler in _specialMoveHandlers) {
      handler.handle(piece, newRow, newColumn, boardState);
    }

    // Record the move
    boardState.addMove(Move(
      fromRow: piece.row,
      fromColumn: piece.column,
      toRow: newRow,
      toColumn: newColumn,
      piece: piece,
      capturedPiece: targetPiece,
    ));
    
    // Update piece position
    piece.row = newRow;
    piece.column = newColumn;
    piece.hasMoved = true;
  }
}
