import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/theme_mode_provider.dart';
import 'package:retro_bank_app/core/common/app/providers/user_provider.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  ThemeModeProvider get themeProvider => read<ThemeModeProvider>();

  UserProvider get userProvider => read<UserProvider>();

  LocalUserModel? get user => userProvider.user;
}
