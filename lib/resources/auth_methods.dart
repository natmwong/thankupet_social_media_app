import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/utils/utils.dart';

class AuthMethods {
  final SupabaseClient _supabase = Supabase.instance.client;
  Session? session;

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          confirmPassword.isNotEmpty) {
        if (password != confirmPassword) {
          res = "Please confirm password";
        } else {
          final success = await _supabase.auth.signUp(
            email: email,
            password: password,
            data: {
              'username': username,
            },
          );
          session = success.session;
          final User? user = success.user;
          res = "success";
        }
      } else {
        res = "Please enter all the fields";
      }
    } on AuthException catch (err) {
      res = err.message;
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _supabase.auth
            .signInWithPassword(email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on AuthException catch (err) {
      res = err.message;
    }
    return res;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
