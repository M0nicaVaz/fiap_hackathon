import 'package:fiap_hackathon/core/design_system/themes/color_themes.dart';
import 'package:flutter/foundation.dart';

class AccessibilityController extends ChangeNotifier {
  ColorThemeType colorTheme = ColorThemeType.standard;

  double fontScale = 1.0;

  void setFontScale(double scale) {
    fontScale = scale;
    notifyListeners();
  }

  void setTheme(ColorThemeType theme) {
    colorTheme = theme;
    notifyListeners();
  }
}
