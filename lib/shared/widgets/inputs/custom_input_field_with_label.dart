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
  final IconData? prefixIcon;

  const CustomInputFieldWithLabel({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.label,
    this.controller,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15 * textScale,
            color: textColor,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        CustomInputField(
          hintText: hintText,
          obscureText: obscureText,
          controller: controller,
          validator: validator,
        ),
      ],
    );
  }
}