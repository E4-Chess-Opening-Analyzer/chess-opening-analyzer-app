import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/type/pawn.dart';
import 'package:app/models/pieces/piece.dart';

class LightPawn extends Piece with Light, Pawn {
  LightPawn({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_PAWN;
  }
}
