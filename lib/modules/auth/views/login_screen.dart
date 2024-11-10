
import 'package:afrika_baba/modules/auth/views/forget_password_screen.dart';
import 'package:afrika_baba/modules/home/views/home_page.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/DividerWithText.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/buttons/social_button.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAppColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              RichText(text: const TextSpan(children: [
                const TextSpan(
                  text: 'Bienvenue,',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor
                  ),
                ),
                TextSpan(
                  text: 'Innovatelq ',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColorSecond,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
              const SizedBox(height: 30),
              CustomInputField(
                hintText: 'Mot de passe',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(   
                  onTap: () {
                    Get.to(() => ForgetPasswordScreen());
                  },
                  child: const Text(
                    'Mot de passe oublié?',
                    style: TextStyle(
                      color: textColorSecond,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Connexion',
                onPressed: () {
                  Get.to(() => HomePage());
                },
              ),
    
              const SizedBox(height: 20),
              DividerWithText(text: 'ou encore'),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SocialButton(iconpath: "assets/facebook.png", onPressed: () {}),
                SocialButton(iconpath: "assets/Apple.png", onPressed: () {}),  
                SocialButton(iconpath: "assets/gmail.png", onPressed: () {
                  
                }),
           
              ]),
              const SizedBox(height: 50),
              Align(
                child: RichText(
                  text: TextSpan(
                    text: 'Pas de compte? ',
                    style: TextStyle(color: Colors.grey[600]),
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const TextSpan(
                        text: 's’inscrire',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        
                      ),
                    ],
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}