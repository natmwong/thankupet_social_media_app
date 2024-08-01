import "package:supabase_flutter/supabase_flutter.dart";

/// Represents a post in the application.
class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String datePublished;
  final String imageUrl;
  final String profImage;
  final likes;

  /// Constructs a post object.
  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.imageUrl,
    required this.profImage,
    required this.likes,
  });

  /// Converts the post object to a JSON representation.
  Map<String, dynamic> toJson() => {
        "description": description,
        "user_id": uid,
        "username": username,
        "id": postId,
        "date_published": datePublished,
        "image_url": imageUrl,
        "profimg_url": profImage,
        "likes": likes,
      };

  // Constructs a post from json format
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      description: json['description'],
      uid: json['user_id'],
      username: json['username'],
      postId: json['id'],
      datePublished: json['date_published'].toString(),
      imageUrl: json['image_url'],
      profImage: json['profimg_url'],
      likes: json['likes'],
    );
  }
}
