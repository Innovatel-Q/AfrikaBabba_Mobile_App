import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class CustomAlertDialogue extends StatelessWidget {
  final String title;
  final String content;
  final String canceledText;
  final String confirmationText;
  final VoidCallback canceledFunction;
  final VoidCallback confirmationFunction;

  const CustomAlertDialogue({
    super.key,
    required this.title,
    required this.content,
    required this.canceledText,
    required this.confirmationText,
    required this.canceledFunction,
    required this.confirmationFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: canceledFunction, // Appel correct
          child: Text(
            canceledText,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: confirmationFunction, // Appel correct
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmationText,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
