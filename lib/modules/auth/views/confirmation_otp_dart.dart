
import 'package:afrika_baba/modules/auth/views/new_password_screnn.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/buttons/otp_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationOtpDart extends StatelessWidget {
  const ConfirmationOtpDart({super.key});

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
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
                  onPressed: () {
                   Get.back();
                  },
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'confirmation \nde l\'email',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: btnColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'veuillez saisir le code OTP qui\nvous a été envoyé',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OtpInputField(),
                    OtpInputField(),
                    OtpInputField(),
                    OtpInputField(),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 45, top: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: 'renvoyer sur ',
                        style: TextStyle(color: Colors.grey[600]),
                        children: const [
                          TextSpan(
                            text: '00:32',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                CustomButton(
                  text: 'Envoyez',
                  color: btnColorFourth,
                  onPressed: () {
                    Get.offAll(() => NewPasswordScreen());
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