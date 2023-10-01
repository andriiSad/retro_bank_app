part of 'injection_container.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  //use registerFactory for registering blocs
  //use registerLazySingleton for registering dependencies
  //we always start from top, from blocs
  // Feature  => OnBoarding

  await _initOnBoarding(prefs);
  await _initAuth();
}

Future<void> _initAuth() async {
  serviceLocator
    //Buisness Logic
    ..registerFactory(
      () => AuthBloc(
        signIn: serviceLocator(),
        signUp: serviceLocator(),
        forgotPassword: serviceLocator(),
        updateUser: serviceLocator(),
        signOut: serviceLocator(),
      ),
    )

    //Use cases
    ..registerLazySingleton(() => SignIn(serviceLocator()))
    ..registerLazySingleton(() => SignUp(serviceLocator()))
    ..registerLazySingleton(() => ForgotPassword(serviceLocator()))
    ..registerLazySingleton(() => UpdateUser(serviceLocator()))
    ..registerLazySingleton(() => SignOut(serviceLocator()))

    //Repositories
    //because we register interface but passing impl, we specify type
    ..registerLazySingleton<IAuthRepo>(
      () => AuthRepoImpl(serviceLocator()),
    )

    //Data Sources
    ..registerLazySingleton<IAuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: serviceLocator(),
        cloudStoreClient: serviceLocator(),
        dbClient: serviceLocator(),
      ),
    )

    //External Dependencies
    ..registerLazySingleton(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton(
      () => FirebaseStorage.instance,
    );
}

Future<void> _initOnBoarding(SharedPreferences prefs) async {
  serviceLocator
    //Buisness Logic
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: serviceLocator(),
        checkIfUserIsFirstTimer: serviceLocator(),
      ),
    )

    //Use cases
    ..registerLazySingleton(() => CacheFirstTimer(serviceLocator()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(serviceLocator()))

    //Repositories
    ..registerLazySingleton<IOnBoardingRepo>(
      () => OnBoardingRepoImpl(serviceLocator()),
    )

    //Data Sources
    ..registerLazySingleton<IOnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(serviceLocator()),
    )

    //External Dependencies
    ..registerLazySingleton(
      () => prefs,
    );
}
