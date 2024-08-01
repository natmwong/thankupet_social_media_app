import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/models/post.dart';
import 'package:uuid/uuid.dart';

/// A class that provides methods for storing user data and avatars.
class StorageMethods {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Updates a user's avatar and profile information(fullName, pronouns, and bio).
  ///
  /// Returns a [String] indicating the result of the update process.
  /// Possible values are:
  /// - "success" if the update was successful.
  /// - "Please enter name, pronouns, and bio" if any of the required fields are empty.
  /// - "Some error occurred" if an error occurred during the update process.
  Future<String> updateUser(
      {required XFile? file,
      required String name,
      required String pronouns,
      required String bio}) async {
    String res = "Some error occurred";
    try {
      if (file != null &&
          name.isNotEmpty &&
          pronouns.isNotEmpty &&
          bio.isNotEmpty) {
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

        // insert updated current user data into profiles datatable
        await _supabase.from('profiles').upsert([
          {
            'full_name': name,
            'avatar_url': avatarUrl,
            'pronouns': pronouns,
            'bio': bio,
          }
        ]).eq('id', userId);
        res = "success";
      } else {
        res = "Please enter name, pronouns, and bio";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  /// Uploads a post to Supabase.
  ///
  /// Parameters:
  /// - [description]: The description of the post.
  /// - [file]: The image file of the post.
  /// - [uid]: The user ID of the post creator.
  /// - [username]: The username of the post creator.
  /// - [profImage]: The profile image URL of the post creator.
  ///
  /// Returns:
  /// - A [Future] that completes with a [String] indicating the result of the upload.
  ///   - If the upload is successful, the [String] will be "success".
  ///   - If an error occurs, the [String] will contain the error message.
  Future<String> uploadPost(
    String description,
    XFile? file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      if (description.isNotEmpty &&
          file != null &&
          uid.isNotEmpty &&
          username.isNotEmpty &&
          profImage.isNotEmpty) {
        final bytes = await file.readAsBytes();
        final userId = _supabase.auth.currentUser!.id;
        final fileExt = file.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = fileName;
        await _supabase.storage.from('postImages').uploadBinary(
              filePath,
              bytes,
              fileOptions: FileOptions(contentType: file.mimeType),
            );
        final postImageUrl =
            _supabase.storage.from('postImages').getPublicUrl(filePath);

        // create a unique id for the post
        String postId = const Uuid().v1();

        // insert new post data into posts datatable
        await _supabase.from('posts').insert({
          'id': postId,
          'user_id': userId,
          'username': username,
          'description': description,
          'image_url': postImageUrl,
          'profimg_url': profImage
        });

        final data =
            _supabase.from('posts').select('*').eq('id', postId).single();
        Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now().toString(),
          imageUrl: postImageUrl,
          profImage: profImage,
          likes: [],
        );

        res = "success";
      } else {
        res = "Please fill out all information";
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }
}
