import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A class that provides methods for storing user data and avatars.
class StorageMethods {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Updates a user's avatar and profile information.
  ///
  /// Returns a [String] indicating the result of the update process.
  /// Possible values are:
  /// - "success" if the update was successful.
  /// - "Please enter name, pronouns, and bio" if any of the required fields are empty.
  /// - "Some error occurred" if an error occurred during the update process.
  Future<String> updateUser(
      {required XFile file,
      required String name,
      required String pronouns,
      required String bio}) async {
    String res = "Some error occurred";
    try {
      if (name.isNotEmpty && pronouns.isNotEmpty && bio.isNotEmpty) {
        final bytes = await file.readAsBytes();
        final userId = _supabase.auth.currentUser!.id;
        final fileExt = file.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await _supabase.storage.from('avatars').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: file.mimeType),
            );
        final avatarUrl =
            _supabase.storage.from('avatars').getPublicUrl(filePath);
        await _supabase.from('profiles').upsert([
          {
            'id': userId,
            'full_name': name,
            'avatar_url': avatarUrl,
            'pronouns': pronouns,
            'bio': bio,
          }
        ]);
        res = "success";
      } else {
        res = "Please enter name, pronouns, and bio";
      }
    } catch (e) {
      res = '$e';
    }
    return res;
  }
}
