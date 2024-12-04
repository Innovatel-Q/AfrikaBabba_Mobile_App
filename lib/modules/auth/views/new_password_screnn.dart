import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/modules/auth/views/login_screen.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

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
                const Text(
                  'créer un nouveau',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text('mot de passe',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: textColorSecond,fontFamily: 'poppins'),),
                const SizedBox(height: 25),
                const Text(
                  textAlign: TextAlign.start,
                  "Maintenant, vous pouvez créer un nouveau mot de passe et le confirmer ci-dessous",
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 30),
              
                const CustomInputField(
                  hintText: 'Mot de passe',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                const CustomInputField(
                  hintText: 'Confirmer votre mot de passe',
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'suivant',
                  color: btnColorThird,
                  onPressed: () {
                    Get.offAll(() => LoginScreen());
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