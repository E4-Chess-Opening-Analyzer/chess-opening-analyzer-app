import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/rook.dart';

class LightRook extends Piece with Light, Rook {
  LightRook({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_ROOK;
  }
}
