import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/screens/login_screen.dart';
import 'package:thankupet_social_media_app/screens/updateProfile_screen.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://ylkekuxzlzxlhelbzdhg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlsa2VrdXh6bHp4bGhlbGJ6ZGhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIyOTM0NjcsImV4cCI6MjAzNzg2OTQ2N30.E0IlsYWF9BRPmXwdttPVrOP8XgrCAV2F-Jh7jUSqYuY',
  );
  runApp(const PawPost());
}

class PawPost extends StatelessWidget {
  const PawPost({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawPost',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor, fontFamily: 'Quicksand'),
      home: LoginScreen(),
    );
  }
}
