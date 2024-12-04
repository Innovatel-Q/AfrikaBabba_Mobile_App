import 'package:afrika_baba/modules/home/views/home_page.dart';
import 'package:afrika_baba/routes/app_routes.dart';
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
          onPressed: () => Get.toNamed(AppRoutes.HOME),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),
        ),
      ),
      backgroundColor: btnColorFourth,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              child: Hero(
                tag: 'confirmation',
                child: Container(
                  width: width * 0.45,
                  height: width * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green[600],
                    size: width * 0.25,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.06),
            Text(
              "Paiement effectué",
              style: GoogleFonts.poppins(
                fontSize: width * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Votre commande a été\neffectuée avec succès.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            SizedBox(height: height * 0.08),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.HOME),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, height * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Retour à l'accueil",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: btnColorFourth,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

