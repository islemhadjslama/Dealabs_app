import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserManager extends ChangeNotifier {
  User _user;

  UserManager(this._user);

  User get user => _user;

  void updateUser({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
  }) {
    bool changed = false;

    if (name != null && name != _user.name) {
      _user.name = name;
      changed = true;
    }
    if (email != null && email != _user.email) {
      _user.email = email;
      changed = true;
    }
    if (phone != null && phone != _user.phone) {
      _user.phone = phone;
      changed = true;
    }
    if (address != null && address != _user.address) {
      _user.address = address;
      changed = true;
    }
    if (image != null && image != _user.image) {
      _user.image = image;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }
}
