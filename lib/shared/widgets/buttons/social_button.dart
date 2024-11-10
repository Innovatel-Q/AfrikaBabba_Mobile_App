import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String iconpath;
  final VoidCallback onPressed;

  SocialButton({required this.iconpath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(iconpath, width: 30, height: 30),
      onPressed:() => onPressed(),
    );
  }
}