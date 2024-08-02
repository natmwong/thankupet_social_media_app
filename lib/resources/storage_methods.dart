import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// A class that provides methods for storing data for profiles, posts, and comments
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
    String profilePic,
  ) async {
    String res = "some error occurred";
    try {
      if (description.isNotEmpty &&
          file != null &&
          uid.isNotEmpty &&
          username.isNotEmpty &&
          profilePic.isNotEmpty) {
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
          'profimg_url': profilePic
        });

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

  /// Likes or unlikes a post based on whether the user's id is already in the likes or not
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        // Removing the user id from the likes array
        likes.remove(uid);
        final List currentLikes = likes;
        await _supabase
            .from('posts')
            .update({'likes': currentLikes}).eq('id', postId);
      } else {
        // Adding the user id to the likes array
        likes.add(uid);
        final List currentLikes = likes;
        await _supabase
            .from('posts')
            .update({'likes': currentLikes}).eq('id', postId);
      }
    } catch (e) {
      print('Error liking/unliking post: $e');
    }
  }

  /// Deletes a post
  Future<void> deletePost(String postId) async {
    try {
      await _supabase.from('posts').delete().eq('id', postId);
    } catch (err) {
      print(err.toString());
    }
  }

  // Posts a comment on a post.
  Future<String> postComment(String postId, String text, String userId,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _supabase.from('comments').insert({
          'profimg_url': profilePic,
          'username': name,
          'post_id': postId,
          'user_id': userId,
          'content': text,
          'id': commentId,
          'likes': []
        });
        res = "success";
      } else {
        res = "Text is empty";
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

  /// Likes or unlikes a comment based on whether the user's id is already in the likes or not
  Future<void> likeComment(String commentId, String uid, List likes) async {
    List currentLikes;
    try {
      if (likes.contains(uid)) {
        // Removing the user id from the likes array
        likes.remove(uid);
        currentLikes = likes;
        await _supabase
            .from('comments')
            .update({'likes': currentLikes}).eq('id', commentId);
      } else {
        // Adding the user id to the likes array
        likes.add(uid);
        currentLikes = likes;
        await _supabase
            .from('comments')
            .update({'likes': currentLikes}).eq('id', commentId);
      }
    } catch (e) {
      print('Error liking/unliking post: $e');
    }
  }

  /// Follows or unfollows a user based on whether the user's id is already in the follow list or not
  Future<void> followUser(String uid, String followId) async {
    try {
      // Fetch the current user's profile
      final userSnap = await _supabase
          .from('profiles')
          .select('following')
          .eq('id', uid)
          .single();
      List<String> following = List<String>.from(userSnap['following'] ?? []);

      // Fetch the follow target's profile
      final followSnap = await _supabase
          .from('profiles')
          .select('followers')
          .eq('id', followId)
          .single();
      List<String> followers = List<String>.from(followSnap['followers'] ?? []);

      if (following.contains(followId)) {
        // Unfollow: Remove followId from the current user's following list
        following.remove(followId);
        await _supabase
            .from('profiles')
            .update({'following': following}).eq('id', uid);

        // Unfollow: Remove uid from the target user's followers list
        followers.remove(uid);
        await _supabase
            .from('profiles')
            .update({'followers': followers}).eq('id', followId);
      } else {
        // Follow: Add followId to the current user's following list
        following.add(followId);
        await _supabase
            .from('profiles')
            .update({'following': following}).eq('id', uid);

        // Follow: Add uid to the target user's followers list
        followers.add(uid);
        await _supabase
            .from('profiles')
            .update({'followers': followers}).eq('id', followId);
      }
    } catch (e) {
      print('Error following/unfollowing user: $e');
    }
  }
}
