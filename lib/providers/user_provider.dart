import 'package:flutter/material.dart';
import 'package:thankupet_social_media_app/models/user.dart';
import 'package:thankupet_social_media_app/resources/auth_methods.dart';

/// A provider class that manages the user data.
class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  /// Returns the current user.
  User get getUser {
    if (_user == null) {
      throw Exception("User is not set");
    }
    return _user!;
  }

  /// Refreshes the user data by fetching the latest details from the server.
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;

    print('User: $user');
    print('User ID: ${user.username}');
    // Add more properties if needed

    notifyListeners();
  }
}
