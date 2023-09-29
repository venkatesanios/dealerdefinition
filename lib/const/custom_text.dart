import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? initialValue;

  final IconData? prefixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  CustomTextField({
    this.controller,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      initialValue: initialValue,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please enter a username.';
        }
        return null;
      },
    );
  }
}
