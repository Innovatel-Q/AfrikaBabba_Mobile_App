import 'package:flutter/material.dart';
class DividerWithText extends StatelessWidget {
  final String text;
  final double? fontSize;

  DividerWithText({required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.grey[400],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600],fontSize: fontSize ?? 14),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}