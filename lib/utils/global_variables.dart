import 'package:flutter/material.dart';
import 'package:thankupet_social_media_app/screens/add_post_screen.dart';
import 'package:thankupet_social_media_app/screens/feed_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const Text('search'),
  const AddPostScreen(),
  const Text('notif'),
  const Text('profile'),
];
