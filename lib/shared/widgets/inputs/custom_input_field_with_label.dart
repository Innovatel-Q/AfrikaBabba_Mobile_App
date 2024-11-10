import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputFieldWithLabel extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator; 

  CustomInputFieldWithLabel ({required this.hintText, this.obscureText = false, required this.label, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        CustomInputField(hintText: hintText, obscureText: obscureText, controller: controller, validator: validator,),
      ],
    );
  }
}