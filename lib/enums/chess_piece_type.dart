import 'package:app/assets.dart';

enum ChessPieceType {
  lightPawn,
  lightRook,
  lightKnight,
  lightBishop,
  lightQueen,
  lightKing,
  darkPawn,
  darkRook,
  darkKnight,
  darkBishop,
  darkQueen,
  darkKing,
}
extension ChessPieceTypeExtension on ChessPieceType {
  bool get isLight {
    return this == ChessPieceType.lightPawn ||
        this == ChessPieceType.lightRook ||
        this == ChessPieceType.lightKnight ||
        this == ChessPieceType.lightBishop ||
        this == ChessPieceType.lightQueen ||
        this == ChessPieceType.lightKing;
  }

  bool get isDark {
    return this == ChessPieceType.darkPawn ||
        this == ChessPieceType.darkRook ||
        this == ChessPieceType.darkKnight ||
        this == ChessPieceType.darkBishop ||
        this == ChessPieceType.darkQueen ||
        this == ChessPieceType.darkKing;
  }
}
extension ChessPieceTypeImgExtension on ChessPieceType {
  String get imgPath {
    switch (this) {
      case ChessPieceType.lightPawn:
        return IMG_LIGHT_PAWN;
      case ChessPieceType.lightRook:
        return IMG_LIGHT_ROOK;
      case ChessPieceType.lightKnight:
        return IMG_LIGHT_KNIGHT;
      case ChessPieceType.lightBishop:
        return IMG_LIGHT_BISHOP;
      case ChessPieceType.lightQueen:
        return IMG_LIGHT_QUEEN;
      case ChessPieceType.lightKing:
        return IMG_LIGHT_KING;
      case ChessPieceType.darkPawn:
        return IMG_DARK_PAWN;
      case ChessPieceType.darkRook:
        return IMG_DARK_ROOK;
      case ChessPieceType.darkKnight:
        return IMG_DARK_KNIGHT;
      case ChessPieceType.darkBishop:
        return IMG_DARK_BISHOP;
      case ChessPieceType.darkQueen:
        return IMG_DARK_QUEEN;
      case ChessPieceType.darkKing:
        return IMG_DARK_KING;
    }
  }
}
