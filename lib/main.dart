// import 'package:firebase_core/firebase_core.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/theme_mode_provider.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/services/bloc_observer.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/core/services/router/router.dart';
import 'package:retro_bank_app/core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  Bloc.observer = const AppBlocObserver();

  //init service locator
  await init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.themeProvider.initThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.themeProvider.themeMode,
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
