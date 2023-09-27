import 'dart:ui';

import 'package:retro_bank_app/core/extensions/color_extension.dart';

class Colours {
  const Colours._(); // Private constructor to prevent instantiation.

  /// Gradient colors: EDF8FF, FDC1E8, FDFAE1, FFFFFF
  static List<Color> gradient = [
    '#EDF8FF'.toColor(),
    '#FDC1E8'.toColor(),
    '#FFFFFF'.toColor(),
    '#FDFAE1'.toColor(),
  ];

  /// Primary color: 458CFF
  static Color primaryColour = '#458CFF'.toColor();

  /// Neutral text color: 757C8E
  static Color neutralTextColour = '#757C8E'.toColor();

  /// Physics tile color: 0305FE
  static Color physicsTileColour = '#0305FE'.toColor();

  /// Science tile color: FFEFDA
  static Color scienceTileColour = '#FFEFDA'.toColor();

  /// Chemistry tile color: FFE4F1
  static Color chemistryTileColour = '#FFFE4F1'.toColor();

  /// Biology tile color: CFE5FC
  static Color biologyTileColour = '#CFE5FC'.toColor();

  /// Math tile color: DAFFD6
  static Color mathTileColour = '#DAFFD6'.toColor();

  /// Language tile color: 05BEFB
  static Color languageTileColour = '#05BEFB'.toColor();

  /// Literature tile color: FF5C5C1
  static Color literatureTileColour = '#FF5C5C1'.toColor();

  /// White color: FFFFFF
  static Color whiteColour = '#FFFFFF'.toColor();

  /// Green color: 28CA6C
  static Color greenColour = '#28CA6C'.toColor();

  /// Chat field color: F4F5F6
  static Color chatFieldColour = '#F4F5F6'.toColor();

  /// Darker chat field color: E8E9EA
  static Color chatFieldColourDarker = '#E8E9EA'.toColor();

  /// Current user chat bubble color: 2196F3
  static Color currentUserChatBubbleColour = '#2196F3'.toColor();

  /// Other user chat bubble color: EEEEEE
  static Color otherUserChatBubbleColour = '#EEEEEE'.toColor();

  /// Darker current user chat bubble color: 197602
  static Color currentUserChatBubbleColourDarker = '#197602'.toColor();

  /// Darker other user chat bubble color: E0E0E0
  static Color otherUserChatBubbleColourDarker = '#E0E0E0'.toColor();
}
