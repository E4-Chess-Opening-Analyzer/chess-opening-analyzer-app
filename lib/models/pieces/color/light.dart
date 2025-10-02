import 'package:app/models/pieces/color/color.dart';

mixin Light on Color {
  @override
  bool isLight() {
    return true;
  }
  @override
  bool isDark() {
    return false;
  }
}
