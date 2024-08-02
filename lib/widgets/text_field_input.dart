import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thankupet_social_media_app/utils/theme_colors.dart';

/// A custom text field input widget.
class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final IconData? icon;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.icon,
  }) : super(key: key);

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide:
            BorderSide.none); // Remove the border color or make it transparent
    return TextField(
      controller: widget.textEditingController,
      cursorColor: primaryColor,
      style:
          TextStyle(color: primaryColor), // Set the text color to primaryColor
      decoration: InputDecoration(
        labelText: widget.hintText,
        labelStyle: TextStyle(color: secondaryColor),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (Set<WidgetState> states) {
            return TextStyle(color: secondaryColor, letterSpacing: 1.3);
          },
        ),
        border: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(
              color: secondaryColor,
              width: 1.5), // Highlight with secondaryColor when focused
        ),
        enabledBorder: inputBorder,
        filled: true,
        fillColor: secondaryBackgroundColor,
        contentPadding: const EdgeInsets.all(8),
        prefixIcon: widget.icon != null
            ? Icon(
                widget.icon,
                color: secondaryColor,
              )
            : null, // Add prefixIcon based on the icon parameter
        suffixIcon: widget.icon == Icons.lock_rounded
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: secondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null, // Add suffixIcon if the icon is lock_rounded
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass && _obscureText,
    );
  }
}
