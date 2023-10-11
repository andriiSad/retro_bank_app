part of 'router.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  //we provide our blocs here in router
  //when the page is gone, bloc is gone too
  //use sl to get blocs
  switch (settings.name) {
    case '/':
      final prefs = serviceLocator<SharedPreferences>();
      return _pageBuilder(
        (context) {
          // if (prefs.getBool(kFirstTimerKey) ?? true) {
          //   return BlocProvider(
          //     create: (_) => serviceLocator<OnBoardingCubit>(),
          //     child: const OnBoardingScreen(),
          //   );
          // } else if (serviceLocator<FirebaseAuth>().currentUser != null) {
          //   final user = serviceLocator<FirebaseAuth>().currentUser!;
          //   final localUser = LocalUserModel(
          //     id: user.uid,
          //     email: user.email!,
          //     username: user.displayName!,
          //     photoUrl: user.photoURL,
          //   );
          context.userProvider.initUser(LocalUserModel.empty());
          return BlocProvider(
            create: (_) => serviceLocator<AuthBloc>(),
            child: const DashboardScreen(),
          );
        },
        // return BlocProvider(
        //   create: (_) => serviceLocator<AuthBloc>(),
        //   child: const SignInScreen(),
        // );
        // },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case DashboardScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const DashboardScreen(),
        ),
        settings: settings,
      );

    case '/forgot_password':
      return _pageBuilder(
        (_) => const firebase_ui.ForgotPasswordScreen(),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstructionView(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) =>
    PageRouteBuilder<dynamic>(
      pageBuilder: (context, _, __) => page(context),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      settings: settings,
    );
