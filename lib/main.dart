// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/res/fonts.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/core/services/router/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  //init service locator
  await init();

  runApp(
    MaterialApp(
      title: 'Education App',
      theme: ThemeData(
        fontFamily: Fonts.poppins,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colours.primaryColour,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
