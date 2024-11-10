import 'package:afrika_baba/modules/home/views/home_page.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.offAll(() =>  HomePage ());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),
        ),
      ),
      backgroundColor: btnColorFourth, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.4,
              height: width * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.green[600],
                size: width * 0.2,
              ),
            ),
            SizedBox(height: height * 0.05),
            Text(
              "Paiement effectué",
              style: GoogleFonts.poppins(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Votre commande a été\n effectuée avec succès.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

