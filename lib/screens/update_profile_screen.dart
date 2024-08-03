import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thankupet_social_media_app/providers/user_provider.dart';
import 'package:thankupet_social_media_app/resources/storage_methods.dart';
import 'package:thankupet_social_media_app/screens/nav_bar.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';
import 'package:thankupet_social_media_app/utils/utils.dart';
import 'package:thankupet_social_media_app/widgets/text_field_input.dart';

// Update Profile screen allowing users to register their initial profile details
// or update their current details after registration
class UpdateProfileScreen extends StatefulWidget {
  final bool isRegistration; // True for registration, false for editing

  const UpdateProfileScreen({Key? key, required this.isRegistration})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  String _selectedPronouns = 'he/him'; // Default value
  final TextEditingController _bioController = TextEditingController();
  XFile? _image;
  bool _isLoading = false;
  final inputBorder = OutlineInputBorder(borderSide: BorderSide.none);

  /// Allows the user to select an image from the gallery.
  void selectImage() async {
    XFile im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  // On success, updates user's profile information and redirects user to NavBar page.
  // On error, displays a SnackBar with error message.
  void updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    String res = await StorageMethods().updateUser(
      file: _image!,
      name: _fullNameController.text,
      pronouns: _selectedPronouns,
      bio: _bioController.text,
      isRegistration: widget.isRegistration,
    );

    // // Refresh user data in provider
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar(
        widget.isRegistration ? 'Registration complete' : 'Profile updated',
        context,
      );
      if (widget.isRegistration) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NavBar(),
          ),
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: secondaryBackgroundColor,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 3),
                Text(
                  widget.isRegistration
                      ? 'Tell us more about yourself.'
                      : 'Edit your profile.',
                  style: GoogleFonts.quicksand(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                // Circular widget to accept and show our selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(File(_image!.path)),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Text field input for name
                TextFieldInput(
                  hintText: 'Name',
                  textInputType: TextInputType.text,
                  textEditingController: _fullNameController,
                ),
                const SizedBox(height: 24),
                // Dropdown menu for pronouns
                DropdownButtonFormField<String>(
                  value: _selectedPronouns,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPronouns = newValue!;
                    });
                  },
                  style: TextStyle(color: primaryColor),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: secondaryColor),
                    floatingLabelStyle: MaterialStateTextStyle.resolveWith(
                      (Set<MaterialState> states) {
                        return TextStyle(
                            color: secondaryColor, letterSpacing: 1.3);
                      },
                    ),
                    border: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(
                          color: secondaryColor,
                          width:
                              1.5), // Highlight with secondaryColor when focused
                    ),
                    enabledBorder: inputBorder,
                    filled: true,
                    fillColor: secondaryBackgroundColor,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'he/him',
                      child: Text('He/Him'),
                    ),
                    DropdownMenuItem(
                      value: 'she/her',
                      child: Text('She/Her'),
                    ),
                    DropdownMenuItem(
                      value: 'they/them',
                      child: Text('They/Them'),
                    ),
                    DropdownMenuItem(
                      value: 'Prefer not to say',
                      child: Text('Prefer not to say'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Text field input for bio
                TextFieldInput(
                  hintText: 'Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                ),
                const SizedBox(height: 24),
                // Button for updating profile
                InkWell(
                  onTap: updateProfile,
                  child: Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : Text(
                            widget.isRegistration ? 'Next' : 'Done',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
