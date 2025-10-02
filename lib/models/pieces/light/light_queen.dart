import 'package:app/assets.dart';
import 'package:app/models/pieces/color/light.dart';
import 'package:app/models/pieces/piece.dart';
import 'package:app/models/pieces/type/queen.dart';

class LightQueen extends Piece with Light, Queen {
  LightQueen({
    required super.row,
    required super.column,
    required super.hasMoved,
  });

  @override
  String getAssetPath() {
    return IMG_LIGHT_QUEEN;
  }
}
