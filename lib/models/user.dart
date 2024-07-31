/// Represents a user in the application.
class User {
  final String uid;
  final String updatedAt;
  final String username;
  final String fullName;
  final String avatarUrl;
  final String pronouns;
  final String bio;
  final List followers;
  final List following;

  /// Constructs a new [User] instance.
  const User({
    required this.uid,
    required this.updatedAt,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    required this.pronouns,
    required this.bio,
    required this.followers,
    required this.following,
  });

  /// Converts the [User] object to a JSON representation.
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "updatedAt": updatedAt,
        "username": username,
        "fullName": fullName,
        "avatarUrl": avatarUrl,
        "pronouns": pronouns,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  //Constructs a [User] from json fromat
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['id'],
      updatedAt: json['updated_at'].toString(),
      username: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      pronouns: json['pronouns'],
      bio: json['bio'],
      followers: List<String>.from(json['followers']),
      following: List<String>.from(json['following']),
    );
  }
}
