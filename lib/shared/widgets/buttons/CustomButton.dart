import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? elevation;
  final double? size;

  const CustomButton({super.key, required this.text, required this.onPressed, this.color, this.textColor, this.elevation, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          elevation: elevation ?? 1,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: color ?? btnColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: size ?? 17,
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
