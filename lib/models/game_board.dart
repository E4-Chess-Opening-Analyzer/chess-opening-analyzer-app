import 'package:app/models/board/board_state.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/king.dart';
import 'package:app/services/board_initializer.dart';
import 'package:app/services/castling_handler.dart';
import 'package:app/services/en_passant_handler.dart';
import 'package:app/services/move_validator.dart';
import 'package:app/services/check_detector.dart';
import 'package:app/services/move_executor.dart';
import 'package:app/services/special_move_handlers.dart';

class GameBoard {
  GameBoard({
    BoardInitializer? initializer,
    MoveValidator? moveValidator,
    CheckDetector? checkDetector,
    MoveExecutor? moveExecutor,
  }) {
    _boardState = BoardState();
    _checkDetector = checkDetector ?? StandardCheckDetector();
    _moveValidator = moveValidator ?? StandardMoveValidator(_checkDetector);
    _moveExecutor = moveExecutor ?? StandardMoveExecutor(<SpecialMoveHandler>[
      CastlingHandler(),
      EnPassantHandler(),
    ]);
    _initializer = initializer ?? StandardBoardInitializer();
    
    _initializer.initialize(_boardState);
  }

  late final BoardState _boardState;
  late final BoardInitializer _initializer;
  late final MoveValidator _moveValidator;
  late final CheckDetector _checkDetector;
  late final MoveExecutor _moveExecutor;

  // Delegate methods
  List<Piece> get pieces => _boardState.pieces;
  bool isLightPieceTurn() => _boardState.isLightTurn();
  bool isDarkPieceTurn() => _boardState.isDarkTurn();
  
  Piece? getPieceAt(int row, int column) => _boardState.getPieceAt(row, column);
  
  bool isInCheck(bool lightKing) => _checkDetector.isInCheck(lightKing, _boardState);
  bool isCheckmate(bool lightKing) => _checkDetector.isCheckmate(lightKing, _boardState);
  bool caseIsUnderAttack(int row, int column, bool byLight) => 
    _checkDetector.caseIsUnderAttack(row, column, byLight, _boardState);
      
  void movePiece(Piece piece, int newRow, int newColumn) =>
    _moveExecutor.executeMove(piece, newRow, newColumn, _boardState);

  List<(int, int)> getPossibleMoves(Piece piece) {
    // For kings, use their special getLegalMoves method
    if (piece is King) {
      return piece.getLegalMoves(_boardState);
    }
    
    // For other pieces, get raw moves and filter for check
    List<(int, int)> rawMoves = piece.getRawPossibleMoves(_boardState);
    return _moveValidator.filterLegalMoves(piece, rawMoves, _boardState);
  }
}
