import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:thankupet_social_media_app/resources/auth_methods.dart";
import "package:thankupet_social_media_app/screens/login_screen.dart";
import "package:thankupet_social_media_app/screens/update_profile_screen.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";
import "package:thankupet_social_media_app/utils/utils.dart";
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  // On success, sign up user and redirect to the UpdateProfileScreen.
  // On error, displays a SnackBar with error message.
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (res == "success") {
      showSnackBar('Signup success!', context);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const UpdateProfileScreen()));
      setState(() {
        _isLoading = false;
      });
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
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
                // text field input for confirming password
                TextFieldInput(
                  hintText: 'Confirm Password',
                  textInputType: TextInputType.text,
                  textEditingController: _confirmPasswordController,
                  isPass: true,
                  icon: Icons.lock_rounded,
                ),
                const SizedBox(height: 24),
                //button signup
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text('Sign up',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500)),
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
                const SizedBox(height: 24),
                //button signout
                InkWell(
                  onTap: () {
                    AuthMethods().signOut();
                    showSnackBar("Signout success", context);
                  },
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text('Sign out',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500)),
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
