import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildProfilOption extends StatelessWidget {

  final String title;
  final Function? onTap;
  final double? width;

  const BuildProfilOption({super.key, required this.title, this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
     return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: width! * 0.04,
          fontWeight: FontWeight.w500,
        ),
        
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {
        onTap!();
      },
    );
  }
}