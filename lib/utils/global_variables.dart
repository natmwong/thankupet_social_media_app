import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/screens/add_post_screen.dart';
import 'package:thankupet_social_media_app/screens/feed_screen.dart';
import 'package:thankupet_social_media_app/screens/profile_screen.dart';
import 'package:thankupet_social_media_app/screens/search_screen.dart';

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(uid: Supabase.instance.client.auth.currentUser!.id),
];
