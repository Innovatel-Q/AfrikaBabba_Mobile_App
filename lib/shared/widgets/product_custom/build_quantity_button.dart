import 'package:flutter/material.dart';

class BuildQuantityButton extends StatelessWidget {

  final IconData icon; 
  final BuildContext context;
  final Function() onPressed;

  const BuildQuantityButton({super.key, required this.icon, required this.context, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(this.context).size.width;
    // final height = MediaQuery.of(this.context).size.height;
    return Container(
      width: width * 0.05,
      height: width * 0.05,
      decoration: BoxDecoration(    
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: width * 0.045),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
  }