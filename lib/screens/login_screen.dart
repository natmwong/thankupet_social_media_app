import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:thankupet_social_media_app/resources/auth_methods.dart";
import "package:thankupet_social_media_app/screens/nav_bar.dart";
import "package:thankupet_social_media_app/screens/signup_screen.dart";
import "package:thankupet_social_media_app/utils/utils.dart";
import "package:thankupet_social_media_app/widgets/logo_text.dart";
import "package:thankupet_social_media_app/widgets/text_field_input.dart";
import "package:thankupet_social_media_app/utils/theme_colors.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  // On success, user is logged in and redirected to home page.
  // On error, displays a SnackBar with error message.
  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      showSnackBar('Login success!', context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const NavBar()));
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 2),
                LogoText(),
                const SizedBox(height: 64),
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
                  icon: Icons.lock_rounded,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                //button login
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
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
                        "Don't have an account yet? ",
                        style: GoogleFonts.quicksand(
                            fontSize: 16.0, color: primaryColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        child: Text(
                          "Sign up",
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
