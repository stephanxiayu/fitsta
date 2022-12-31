import 'package:fitsta/model/user.dart';
import 'package:fitsta/resurces/auth_methode.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  Users? _user;
  final AuthMethode _authMethode = AuthMethode();

  Users get getUser => _user!;

  Future<void> refreshUser() async {
    Users user = await _authMethode.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
