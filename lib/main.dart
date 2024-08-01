import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thankupet_social_media_app/providers/user_provider.dart';
import 'package:thankupet_social_media_app/screens/login_screen.dart';
import 'package:thankupet_social_media_app/screens/nav_bar.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ylkekuxzlzxlhelbzdhg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlsa2VrdXh6bHp4bGhlbGJ6ZGhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIyOTM0NjcsImV4cCI6MjAzNzg2OTQ2N30.E0IlsYWF9BRPmXwdttPVrOP8XgrCAV2F-Jh7jUSqYuY',
  );
  runApp(const PawPost());
}

class PawPost extends StatefulWidget {
  const PawPost({super.key});

  @override
  State<PawPost> createState() => _PawPostState();
}

class _PawPostState extends State<PawPost> {
  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    final Session? session = supabase.auth.currentSession;
    late final StreamSubscription<AuthState> _authStateSubscription;

    @override
    void initState() {
      _authStateSubscription = supabase.auth.onAuthStateChange.listen(
        (data) {
          final AuthChangeEvent event = data.event;
          if (event == AuthChangeEvent.signedIn) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const NavBar()));
          } else if (event == AuthChangeEvent.signedOut) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else if (event == AuthChangeEvent.initialSession) {
            if (session != null) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NavBar()));
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          }
        },
      );
      super.initState();
    }

    @override
    void dispose() {
      _authStateSubscription.cancel();
      super.dispose();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'PawPost',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: backgroundColor,
            fontFamily: 'Quicksand',
          ),
          home: session != null ? const NavBar() : const LoginScreen()),
    );
  }
}
