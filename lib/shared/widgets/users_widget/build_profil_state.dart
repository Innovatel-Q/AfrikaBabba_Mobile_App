import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildProfilState extends StatelessWidget {

  final String number;
  final String label;
  final double width;

  const BuildProfilState({super.key, required this.number, required this.label, required this.width});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width * 0.03,
          ),
        ),
      ],
    );
  }
}