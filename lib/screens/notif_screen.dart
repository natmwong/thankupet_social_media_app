import 'package:flutter/material.dart';
import 'package:thankupet_social_media_app/resources/auth_methods.dart';
import 'package:thankupet_social_media_app/screens/login_screen.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthMethods().signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: Text(
            'Sign Out',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ),
    );
  }
}
