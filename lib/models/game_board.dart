import 'package:app/models/move.dart';
import 'package:app/models/piece.dart';
import 'package:app/enums/chess_piece_type.dart';

class GameBoard {
  GameBoard() {
    _initializeBoard();
  }

  final List<Piece> pieces = <Piece>[];
  final List<Move> moveHistory = <Move>[];
  
  void _initializeBoard() {
    // Initialize light pieces
    pieces.addAll(<Piece>[
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
    pieces.addAll(<Piece>[
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
      (Piece piece) => piece.type == (lightKing ? ChessPieceType.lightKing : ChessPieceType.darkKing),
    );
    List<(int, int)> kingMoves = getPossibleMoves(king);
    if (kingMoves.isNotEmpty) {
      return false;
    }

    // Check if any other piece can block the check or capture the attacking piece
    for (Piece piece in pieces) {
      if ((lightKing && piece.type.isLight) || (!lightKing && piece.type.isDark)) {
        List<(int, int)> moves = getPossibleMoves(piece);
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
    if (piece.type == ChessPieceType.lightPawn 
      && piece.row == 4 && newRow == 5 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = getPieceAt(4, newColumn);
      if (enPassantTarget != null && enPassantTarget.type == ChessPieceType.darkPawn) {
        removePiece(enPassantTarget);
      }
    } else if (piece.type == ChessPieceType.darkPawn 
      && piece.row == 3 && newRow == 2 
      && (newColumn == piece.column - 1 || newColumn == piece.column + 1)) {
      Piece? enPassantTarget = getPieceAt(3, newColumn);
      if (enPassantTarget != null && enPassantTarget.type == ChessPieceType.lightPawn) {
        removePiece(enPassantTarget);
      }
    }

    // Castling
    if (piece.type == ChessPieceType.lightKing && !piece.hasMoved) {
      if (newColumn == 6 && newRow == 0) { // Kingside
        Piece? rook = getPieceAt(0, 7);
        if (rook != null && rook.type == ChessPieceType.lightRook && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2 && newRow == 0) { // Queenside
        Piece? rook = getPieceAt(0, 0);
        if (rook != null && rook.type == ChessPieceType.lightRook && !rook.hasMoved) {
          rook.row = 0;
          rook.column = 3;
          rook.hasMoved = true;
        }
      }
    } else if (piece.type == ChessPieceType.darkKing && !piece.hasMoved) {
      if (newColumn == 6 && newRow == 7) { // Kingside
        Piece? rook = getPieceAt(7, 7);
        if (rook != null && rook.type == ChessPieceType.darkRook && !rook.hasMoved) {
          rook.row = 7;
          rook.column = 5;
          rook.hasMoved = true;
        }
      } else if (newColumn == 2 && newRow == 7) { // Queenside
        Piece? rook = getPieceAt(7, 0);
        if (rook != null && rook.type == ChessPieceType.darkRook && !rook.hasMoved) {
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

  List<(int, int)> getPossibleMoves(Piece piece) {
    List<(int, int)> rawMoves;
    
    switch (piece.type) {
      case ChessPieceType.lightPawn:
        rawMoves = _getPossibleMovesLightPawn(piece);
        break;
      case ChessPieceType.darkPawn:
        rawMoves = _getPossibleMovesDarkPawn(piece);
        break;
      case ChessPieceType.lightRook:
        rawMoves = _getPossibleMovesLightRook(piece);
        break;
      case ChessPieceType.darkRook:
        rawMoves = _getPossibleMovesDarkRook(piece);
        break;
      case ChessPieceType.lightKnight:
        rawMoves = _getPossibleMovesLightKnight(piece);
        break;
      case ChessPieceType.darkKnight:
        rawMoves = _getPossibleMovesDarkKnight(piece);
        break;
      case ChessPieceType.lightBishop:
        rawMoves = _getPossibleMovesLightBishop(piece);
        break;
      case ChessPieceType.darkBishop:
        rawMoves = _getPossibleMovesDarkBishop(piece);
        break;
      case ChessPieceType.lightQueen:
        rawMoves = _getPossibleMovesLightQueen(piece);
        break;
      case ChessPieceType.darkQueen:
        rawMoves = _getPossibleMovesDarkQueen(piece);
        break;
      case ChessPieceType.lightKing:
        return _getPossibleMovesLightKing(piece); // Kings have special check logic
      case ChessPieceType.darkKing:
        return _getPossibleMovesDarkKing(piece); // Kings have special check logic
    }
    
    // Filter moves that would leave the king in check
    return _filterMovesForCheck(piece, rawMoves);
  }

  List<(int, int)> _filterMovesForCheck(Piece piece, List<(int, int)> moves) {
    List<(int, int)> legalMoves = <(int, int)>[];
    
    for ((int, int) move in moves) {
      if (_isMoveLegal(piece, move.$1, move.$2)) {
        legalMoves.add(move);
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
    bool isLegal = !isInCheck(piece.type.isLight);
    
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
      if ((byLight && piece.type.isLight) ||
          (!byLight && piece.type.isDark)) {
        
        // Skip kings to avoid infinite recursion during legal move calculation
        if (ignoreKings && (piece.type == ChessPieceType.lightKing || piece.type == ChessPieceType.darkKing)) {
          continue;
        }
        
        // For attack calculations, use raw moves without check filtering
        List<(int, int)> possibleMoves = _getRawPossibleMoves(piece);
        if (possibleMoves.any(((int, int) move) => move == (row, column))) {
          return true;
        }
      }
    }
    return false;
  }

  List<(int, int)> _getRawPossibleMoves(Piece piece) {
    switch (piece.type) {
      case ChessPieceType.lightPawn:
        return _getPossibleMovesLightPawn(piece);
      case ChessPieceType.darkPawn:
        return _getPossibleMovesDarkPawn(piece);
      case ChessPieceType.lightRook:
        return _getPossibleMovesLightRook(piece);
      case ChessPieceType.darkRook:
        return _getPossibleMovesDarkRook(piece);
      case ChessPieceType.lightKnight:
        return _getPossibleMovesLightKnight(piece);
      case ChessPieceType.darkKnight:
        return _getPossibleMovesDarkKnight(piece);
      case ChessPieceType.lightBishop:
        return _getPossibleMovesLightBishop(piece);
      case ChessPieceType.darkBishop:
        return _getPossibleMovesDarkBishop(piece);
      case ChessPieceType.lightQueen:
        return _getPossibleMovesLightQueen(piece);
      case ChessPieceType.darkQueen:
        return _getPossibleMovesDarkQueen(piece);
      case ChessPieceType.lightKing:
        return _getRawKingMoves(piece);
      case ChessPieceType.darkKing:
        return _getRawKingMoves(piece);
    }
  }

  List<(int, int)> _getRawKingMoves(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        possibleMoves.add((newRow, newCol));
      }
    }

    return possibleMoves;
  }

  bool isInCheck(bool lightKing) {
    Piece king = pieces.firstWhere(
      (Piece piece) => piece.type == (lightKing ? ChessPieceType.lightKing : ChessPieceType.darkKing),
    );
    return caseIsUnderAttack(king.row, king.column, !lightKing);
  }

  List<(int, int)> _getPossibleMovesLightPawn(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    int direction = 1; // Light pawns move "down" the board

    // Move forward one square
    if (piece.row + direction < 8 && getPieceAt(piece.row + direction, piece.column) == null) {
      possibleMoves.add((piece.row + direction, piece.column));

      // Move forward two squares from starting position
      if (!piece.hasMoved && piece.row + 2 * direction < 8 && getPieceAt(piece.row + 2 * direction, piece.column) == null) {
        possibleMoves.add((piece.row + 2 * direction, piece.column));
      }
    }

    // Capture diagonally
    if (piece.row + direction < 8 && piece.column - 1 >= 0) {
      Piece? targetPiece = getPieceAt(piece.row + direction, piece.column - 1);
      if (targetPiece != null && targetPiece.type.toString().startsWith('ChessPieceType.dark')) {
        possibleMoves.add((piece.row + direction, piece.column - 1));
      }
    }
    if (piece.row + direction < 8 && piece.column + 1 < 8) {
      Piece? targetPiece = getPieceAt(piece.row + direction, piece.column + 1);
      if (targetPiece != null && targetPiece.type.toString().startsWith('ChessPieceType.dark')) {
        possibleMoves.add((piece.row + direction, piece.column + 1));
      }
    }

    // En passant
    if (moveHistory.isNotEmpty) {
      Move lastMove = moveHistory.last;
      if (lastMove.piece.type == ChessPieceType.darkPawn &&
          lastMove.fromRow == 6 &&
          lastMove.toRow == 4 &&
          (lastMove.toColumn == piece.column - 1 || lastMove.toColumn == piece.column + 1) &&
          piece.row == 4) {
        possibleMoves.add((piece.row + direction, lastMove.toColumn));
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkPawn(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    int direction = -1; // Dark pawns move "up" the board

    // Move forward one square
    if (piece.row + direction >= 0 && getPieceAt(piece.row + direction, piece.column) == null) {
      possibleMoves.add((piece.row + direction, piece.column));

      // Move forward two squares from starting position
      if (!piece.hasMoved && piece.row + 2 * direction >= 0 && getPieceAt(piece.row + 2 * direction, piece.column) == null) {
        possibleMoves.add((piece.row + 2 * direction, piece.column));
      }
    }

    // Capture diagonally
    if (piece.row + direction >= 0 && piece.column - 1 >= 0) {
      Piece? targetPiece = getPieceAt(piece.row + direction, piece.column - 1);
      if (targetPiece != null && targetPiece.type.toString().startsWith('ChessPieceType.light')) {
        possibleMoves.add((piece.row + direction, piece.column - 1));
      }
    }
    if (piece.row + direction >= 0 && piece.column + 1 < 8) {
      Piece? targetPiece = getPieceAt(piece.row + direction, piece.column + 1);
      if (targetPiece != null && targetPiece.type.toString().startsWith('ChessPieceType.light')) {
        possibleMoves.add((piece.row + direction, piece.column + 1));
      }
    }

    // En passant
    if (moveHistory.isNotEmpty) {
      Move lastMove = moveHistory.last;
      if (lastMove.piece.type == ChessPieceType.lightPawn &&
          lastMove.fromRow == 1 &&
          lastMove.toRow == 3 &&
          (lastMove.toColumn == piece.column - 1 || lastMove.toColumn == piece.column + 1) &&
          piece.row == 3) {
        possibleMoves.add((piece.row + direction, lastMove.toColumn));
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesLightRook(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Vertical and horizontal moves
    List<(int, int)> directions = <(int, int)>[(1, 0), (-1, 0), (0, 1), (0, -1)];
    for (var (int dRow, int dCol) in directions) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      while (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null) {
          possibleMoves.add((newRow, newCol));
        } else {
          if (targetPiece.type.isDark) {
            possibleMoves.add((newRow, newCol));
          }
          break; // Stop if we hit another piece
        }
        newRow += dRow;
        newCol += dCol;
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkRook(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Vertical and horizontal moves
    List<(int, int)> directions = <(int, int)>[(1, 0), (-1, 0), (0, 1), (0, -1)];
    for (var (int dRow, int dCol) in directions) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      while (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null) {
          possibleMoves.add((newRow, newCol));
        } else {
          if (targetPiece.type.isLight) {
            possibleMoves.add((newRow, newCol));
          }
          break; // Stop if we hit another piece
        }
        newRow += dRow;
        newCol += dCol;
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesLightKnight(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> knightMoves = <(int, int)>[
      (2, 1), (2, -1), (-2, 1), (-2, -1),
      (1, 2), (1, -2), (-1, 2), (-1, -2)
    ];

    for (var (int dRow, int dCol) in knightMoves) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.type.isDark) {
          possibleMoves.add((newRow, newCol));
        }
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkKnight(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> knightMoves = <(int, int)>[
      (2, 1), (2, -1), (-2, 1), (-2, -1),
      (1, 2), (1, -2), (-1, 2), (-1, -2)
    ];

    for (var (int dRow, int dCol) in knightMoves) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.type.isLight) {
          possibleMoves.add((newRow, newCol));
        }
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesLightBishop(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Diagonal moves
    List<(int, int)> directions = <(int, int)>[(1, 1), (1, -1), (-1, 1), (-1, -1)];
    for (var (int dRow, int dCol) in directions) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      while (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null) {
          possibleMoves.add((newRow, newCol));
        } else {
          if (targetPiece.type.isDark) {
            possibleMoves.add((newRow, newCol));
          }
          break; // Stop if we hit another piece
        }
        newRow += dRow;
        newCol += dCol;
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkBishop(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Diagonal moves
    List<(int, int)> directions = <(int, int)>[(1, 1), (1, -1), (-1, 1), (-1, -1)];
    for (var (int dRow, int dCol) in directions) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      while (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null) {
          possibleMoves.add((newRow, newCol));
        } else {
          if (targetPiece.type.isLight) {
            possibleMoves.add((newRow, newCol));
          }
          break; // Stop if we hit another piece
        }
        newRow += dRow;
        newCol += dCol;
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesLightQueen(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Combine rook and bishop moves
    possibleMoves.addAll(_getPossibleMovesLightRook(piece));
    possibleMoves.addAll(_getPossibleMovesLightBishop(piece));

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkQueen(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];

    // Combine rook and bishop moves
    possibleMoves.addAll(_getPossibleMovesDarkRook(piece));
    possibleMoves.addAll(_getPossibleMovesDarkBishop(piece));

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesLightKing(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.type.isDark) {
          // Temporarily simulate the move to check if the square would be safe
          if (_isKingMoveSafe(piece, newRow, newCol)) {
            possibleMoves.add((newRow, newCol));
          }
        }
      }
    }

    // Castling - only if not in check and path is clear
    if (!piece.hasMoved && !isInCheck(true)) {
      // Kingside castling
      Piece? rook = getPieceAt(piece.row, 7);
      if (rook != null && rook.type == ChessPieceType.lightRook && !rook.hasMoved) {
        if (getPieceAt(piece.row, 5) == null && getPieceAt(piece.row, 6) == null
          && !caseIsUnderAttack(piece.row, 4, false)
          && !caseIsUnderAttack(piece.row, 5, false)
          && !caseIsUnderAttack(piece.row, 6, false)
        ) {
          possibleMoves.add((piece.row, 6));
        }
      }
      // Queenside castling
      rook = getPieceAt(piece.row, 0);
      if (rook != null && rook.type == ChessPieceType.lightRook && !rook.hasMoved) {
        if (getPieceAt(piece.row, 1) == null && getPieceAt(piece.row, 2) == null && getPieceAt(piece.row, 3) == null
          && !caseIsUnderAttack(piece.row, 4, false)
          && !caseIsUnderAttack(piece.row, 3, false)
          && !caseIsUnderAttack(piece.row, 2, false)
        ) {
          possibleMoves.add((piece.row, 2));
        }
      }
    }

    return possibleMoves;
  }

  List<(int, int)> _getPossibleMovesDarkKing(Piece piece) {
    List<(int, int)> possibleMoves = <(int, int)>[];
    List<(int, int)> kingMoves = <(int, int)>[
      (1, 0), (-1, 0), (0, 1), (0, -1),
      (1, 1), (1, -1), (-1, 1), (-1, -1)
    ];

    for (var (int dRow, int dCol) in kingMoves) {
      int newRow = piece.row + dRow;
      int newCol = piece.column + dCol;
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        Piece? targetPiece = getPieceAt(newRow, newCol);
        if (targetPiece == null || targetPiece.type.isLight) {
          // Temporarily simulate the move to check if the square would be safe
          if (_isKingMoveSafe(piece, newRow, newCol)) {
            possibleMoves.add((newRow, newCol));
          }
        }
      }
    }

    // Castling - only if not in check and path is clear
    if (!piece.hasMoved && !isInCheck(false)) {
      // Kingside castling
      Piece? rook = getPieceAt(piece.row, 7);
      if (rook != null && rook.type == ChessPieceType.darkRook && !rook.hasMoved) {
        if (getPieceAt(piece.row, 5) == null && getPieceAt(piece.row, 6) == null
          && !caseIsUnderAttack(piece.row, 4, true)
          && !caseIsUnderAttack(piece.row, 5, true)
          && !caseIsUnderAttack(piece.row, 6, true)
        ) {
          possibleMoves.add((piece.row, 6));
        }
      }
      // Queenside castling
      rook = getPieceAt(piece.row, 0);
      if (rook != null && rook.type == ChessPieceType.darkRook && !rook.hasMoved) {
        if (getPieceAt(piece.row, 1) == null && getPieceAt(piece.row, 2) == null && getPieceAt(piece.row, 3) == null
          && !caseIsUnderAttack(piece.row, 4, true)
          && !caseIsUnderAttack(piece.row, 3, true)
          && !caseIsUnderAttack(piece.row, 2, true)
        ) {
          possibleMoves.add((piece.row, 2));
        }
      }
    }

    return possibleMoves;
  }

  // New helper method to check if a king move is safe
  bool _isKingMoveSafe(Piece king, int newRow, int newCol) {
    // Save the current state
    int originalRow = king.row;
    int originalCol = king.column;
    Piece? capturedPiece = getPieceAt(newRow, newCol);
    
    // Temporarily make the move
    king.row = newRow;
    king.column = newCol;
    if (capturedPiece != null) {
      pieces.remove(capturedPiece);
    }
    
    // Check if the king would be under attack at the new position
    bool isSafe = !caseIsUnderAttack(newRow, newCol, !king.type.isLight);
    
    // Restore the original state
    king.row = originalRow;
    king.column = originalCol;
    if (capturedPiece != null) {
      pieces.add(capturedPiece);
    }
    
    return isSafe;
  }
}
