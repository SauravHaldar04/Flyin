import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {super.key,
      required this.phoneController,
      required this.hintText,
      this.height,
      this.prefixText,
      this.width,
      this.prefixIcon,
      this.keyboardType,
      this.onFieldSubmitted});
  final Function(String)? onFieldSubmitted;
  final TextEditingController phoneController;
  final String hintText;
  final String? prefixText;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 20),
        keyboardType: keyboardType ?? TextInputType.text,
        controller: phoneController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            prefixIcon: prefixIcon ?? null,
            prefixText: prefixText ?? '',
            prefixStyle: const TextStyle(color: Colors.white, fontSize: 20),
            alignLabelWithHint: true,
            hintStyle: const TextStyle(color: tertiaryColor, fontSize: 20),
            filled: true,
            fillColor: secondaryColor),
        onSubmitted: onFieldSubmitted ?? (value) {},
      ),
    );
  }
}
