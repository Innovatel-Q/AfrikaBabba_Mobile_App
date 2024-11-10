
import 'package:afrika_baba/modules/auth/views/confirmation_otp_dart.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatelessWidget {

  @override

  
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black,size: 35,),
                  onPressed: () {
                    Get.back();
                  },
                ),
                const SizedBox(height: 50),
                Text(
                  'Mot de passe',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600) 
                ),
                Text('oublié',style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: textColorSecond,
                ),),  
                const SizedBox(height: 25),
                Text(
                  textAlign: TextAlign.start,
                  "veuillez saisir votre e-mail ci-dessous et nous vous donnerons le code OTP",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                )),
                const SizedBox(height: 30),
                CustomInputField(
                  hintText: 'Votre e-mail',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Utilisez votre numéro mobile',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColorSecond,
                )),
              ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'suivant',
                  color: btnColorThird,
                  onPressed: () {
                    Get.offAll(() => ConfirmationOtpDart());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}