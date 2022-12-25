import 'package:fitsta/model/user.dart';
import 'package:fitsta/resurces/auth_methode.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethode _authMethode = AuthMethode();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
