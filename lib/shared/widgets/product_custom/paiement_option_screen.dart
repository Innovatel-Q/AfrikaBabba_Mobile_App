import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final String imageUrl;
  final Color? color;
  final bool isSelected;

  const PaymentOption({super.key, required this.imageUrl, this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: width * 0.15,
          height: width * 0.15,
          decoration: BoxDecoration(
            color: color ?? btnColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imageUrl),
          ),
        ),
        Radio(
          value: imageUrl,
          groupValue: 1,
          onChanged: (value) {
            // Action lors de la sélection
          },
          activeColor: Colors.transparent,
        ),
      ],
    );
  }
}