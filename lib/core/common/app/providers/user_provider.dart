import 'package:flutter/foundation.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  set user(LocalUserModel? user) {
    if (_user != user) _user = user;
    Future.delayed(Duration.zero, notifyListeners);
  }

  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }
}
