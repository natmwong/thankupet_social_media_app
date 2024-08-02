import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';

// PawPost logo text widget
class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    // Title
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Paw",
              style: GoogleFonts.quicksand(
                fontSize: 45.0,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),
            Text(
              "Post",
              style: GoogleFonts.quicksand(
                fontSize: 45.0,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 5.0),
            const Icon(
              Icons.pets,
              size: 50.0,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
