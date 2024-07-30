import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:thankupet_social_media_app/screens/login_screen.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";
import "package:thankupet_social_media_app/widgets/logo_text.dart";
import "package:thankupet_social_media_app/widgets/text_field_input.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() {}

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 3),
                // svg image
                LogoText(),
                const SizedBox(height: 44),
                // // circular widget to accept and show our selected file
                // Stack(
                //   children: [
                //     const CircleAvatar(
                //       radius: 64,
                //       backgroundImage: NetworkImage(
                //           'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                //     ),
                //     Positioned(
                //       bottom: -10,
                //       left: 80,
                //       child: IconButton(
                //         onPressed: selectImage,
                //         icon: const Icon(
                //           Icons.add_a_photo,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //const SizedBox(height: 24),
                // text field input for username
                TextFieldInput(
                  hintText: 'Username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 24),
                // text field input for email
                TextFieldInput(
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 24),
                // text field input for password
                TextFieldInput(
                  hintText: 'Password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                  icon: Icons.lock_rounded,
                ),
                const SizedBox(height: 24),
                // text field input for bio
                TextFieldInput(
                  hintText: 'Confirm Password',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  isPass: true,
                  icon: Icons.lock_rounded,
                ),
                const SizedBox(height: 24),
                //button login
                InkWell(
                  //onTap: signUpUser,
                  child: Container(
                    // child: _isLoading
                    //     ? const Center(
                    //         child: CircularProgressIndicator(
                    //           color: primaryColor,
                    //         ),
                    //       )
                    //     :
                    child: Text('Sign up',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w500)),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        color: accentColor),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(child: Container(), flex: 2),

                // Transitioning to signing up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "Already have an account? ",
                        style: GoogleFonts.quicksand(
                          fontSize: 16.0,
                          color: primaryColor,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.quicksand(
                            fontSize: 16.0,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
