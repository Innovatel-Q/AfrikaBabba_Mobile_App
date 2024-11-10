import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator; 

  CustomInputField({
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator, 
      decoration: InputDecoration(
        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: textColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: GoogleFonts.poppins( 
          fontSize: 14,
          color: Colors.red,
        ),
      ),
    );
  }
}
