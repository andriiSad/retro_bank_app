import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IOnBoardingLocalDataSource {
  //no Either return types, datasources throws an error
  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}

class OnBoardingLocalDataSourceImpl implements IOnBoardingLocalDataSource {
  OnBoardingLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheFirstTimer() async {
    // Store a boolean value to indicate that the user
    //has completed onboarding
    try {
      await _prefs.setBool(kFirstTimerKey, false);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    // Retrieve the boolean value to check if the user is a first-timer
    // Default to true if the value is not found
    try {
      return _prefs.getBool(kFirstTimerKey) ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
