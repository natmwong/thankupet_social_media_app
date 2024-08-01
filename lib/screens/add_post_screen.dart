import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thankupet_social_media_app/models/user.dart';
import "package:provider/provider.dart";
import 'package:thankupet_social_media_app/providers/user_provider.dart';
import 'package:thankupet_social_media_app/resources/storage_methods.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';
import 'package:thankupet_social_media_app/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  XFile? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  /// Posts the image to the server.
  ///
  /// Parameters:
  /// - [uid]: The user ID.
  /// - [username]: The username.
  /// - [profImage]: The profile image.
  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await StorageMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  /// Shows a dialog to select an image from the camera or gallery.
  ///
  /// Parameters:
  /// - [context]: The build context.
  Future<void> _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: secondaryBackgroundColor,
            title: const Text(
              'Create a Post',
              style: TextStyle(color: primaryColor),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Take a photo',
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Choose from gallery',
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  XFile file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  /// Clears the selected image.
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    print(user.avatarUrl);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
                size: 30,
                color: primaryColor,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
                onPressed: clearImage,
              ),
              title: Text(
                'New post',
                style: GoogleFonts.quicksand(
                    color: primaryColor, fontWeight: FontWeight.w600),
              ),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.avatarUrl),
                  child: Text(
                    'Post',
                    style: GoogleFonts.quicksand(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        cursorColor: primaryColor,
                        style: TextStyle(color: primaryColor),
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(color: secondaryColor),
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(File(_file!.path)),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
