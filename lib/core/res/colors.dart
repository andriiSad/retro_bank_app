import 'dart:ui';

import 'package:retro_bank_app/core/extensions/color_extension.dart';

class Colours {
  const Colours._(); // Private constructor to prevent instantiation.

  /// Gradient colors:
  static List<Color> purplegradient = [
    '#7573FA'.toColor(),
    '#9A8290'.toColor(),
  ];

  static List<Color> orangeGradient = [
    '#CFAB81'.toColor(),
    '#BD7C5E'.toColor(),
    '#CB6F5A'.toColor(),
  ];

  static List<Color> greenGradient = [
    '#0B705B'.toColor(),
    '#0EB76C'.toColor(),
  ];

  static List<Color> blueGradient = [
    '#104982'.toColor(),
    '#3985D8'.toColor(),
  ];

  static List<Color> torquoiseGradient = [
    '#066C9E'.toColor(),
    '#0B908D'.toColor(),
  ];

  static List<Color> greyBlueGradient = [
    '#304658'.toColor(),
    '#4C6E8C'.toColor(),
  ];
  static List<Color> darkBlueCardGradient = [
    '#080C17'.toColor(),
    '#151C29'.toColor(),
  ];
  static List<Color> lightBlueCardGradient = [
    '#1A4CC2'.toColor(),
    '#1C57B9'.toColor(),
  ];

  static Color inactiveIconColor = '#979797'.toColor();

  static Color activeIconColor = '#F95357'.toColor();

  static Color bottomNavigationBackgroundColor = '#2F2F2F'.toColor();
  static Color transactionsBackgroundColor = '#1E1E1E'.toColor();
  static Color white = '#FFFFFF'.toColor();
  static Color black = '#000000'.toColor();
  static Color inactiveDotColor = '#D9D9D9'.toColor();
}
