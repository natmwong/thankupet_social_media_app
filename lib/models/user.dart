import "package:supabase_flutter/supabase_flutter.dart";

/// Represents a user in the application.
class User {
  final String email;
  final String uid;
  final String avatarUrl;
  final String username;
  final String fullName;
  final String pronouns;
  final String bio;
  final List followers;
  final List following;

  /// Constructs a new [User] instance.
  const User({
    required this.email,
    required this.uid,
    required this.avatarUrl,
    required this.username,
    required this.fullName,
    required this.pronouns,
    required this.bio,
    required this.followers,
    required this.following,
  });

  /// Converts the [User] object to a JSON representation.
  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "avatarUrl": avatarUrl,
        "username": username,
        'fullName': fullName,
        "pronouns": pronouns,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  // /// Creates a [User] object from a [DocumentSnapshot].
  // static User fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return User(
  //     username: snapshot['username'],
  //     uid: snapshot['uid'],
  //     email: snapshot['email'],
  //     photoUrl: snapshot['photoUrl'],
  //     bio: snapshot['bio'],
  //     followers: snapshot['followers'],
  //     following: snapshot['following'],
  //   );
  // }
}
