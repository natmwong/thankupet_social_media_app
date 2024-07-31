import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thankupet_social_media_app/resources/storage_methods.dart';
import 'package:thankupet_social_media_app/screens/nav_bar.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';
import 'package:thankupet_social_media_app/utils/utils.dart';
import 'package:thankupet_social_media_app/widgets/text_field_input.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

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
    );

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar('res', context);
    } else {
      showSnackBar('Registration complete', context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NavBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
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
                    'Tell us more about yourself.',
                    style: GoogleFonts.quicksand(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // circular widget to accept and show our selected file
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
                  // text field input for email
                  TextFieldInput(
                    hintText: 'Name',
                    textInputType: TextInputType.text,
                    textEditingController: _fullNameController,
                  ),
                  const SizedBox(height: 24),
                  // dropdown menu for pronouns
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
                      floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                        (Set<WidgetState> states) {
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
                  // text field input for bio
                  TextFieldInput(
                    hintText: 'Bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                  ),
                  const SizedBox(height: 24),
                  //button login
                  InkWell(
                    onTap: updateProfile,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Text('Next',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
