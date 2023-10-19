import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/cards_provider.dart';
import 'package:retro_bank_app/core/common/app/providers/tab_navigator.dart';
import 'package:retro_bank_app/core/common/app/providers/theme_mode_provider.dart';
import 'package:retro_bank_app/core/common/app/providers/transactions_provider.dart';
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

  CardsProvider get cardsProvider => read<CardsProvider>();

  TransactionsProvider get transactionsProvider => read<TransactionsProvider>();

  LocalUserModel? get user => userProvider.user;

  TabNavigator get tabNavigator => read<TabNavigator>();

  void pop() => tabNavigator.pop();

  void push(Widget page) => tabNavigator.push(TabItem(child: page));

  void popToRoot() => tabNavigator.popToRoot();
}
