import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FormInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const FormInput({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kLogoLightBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}