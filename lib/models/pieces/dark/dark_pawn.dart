import 'package:app/assets.dart';
import 'package:app/models/pieces/color/dark.dart';
import 'package:app/models/pieces/type/pawn.dart';
import 'package:app/models/pieces/piece.dart';

class DarkPawn extends Piece with Dark, Pawn {
  DarkPawn({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_DARK_PAWN;
  }
}
