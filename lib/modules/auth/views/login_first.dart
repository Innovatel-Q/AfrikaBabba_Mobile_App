import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/auth/views/signup_screen.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/utils/validators.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoginFirstScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double scaleFactor = width / 375;
    final double verticalPadding = height * 0.02;
    final double fieldSpacing = verticalPadding;

    return Scaffold(
      backgroundColor: backgroundAppColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 25 * scaleFactor,
              vertical: 15 * scaleFactor
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.08),
                  // Center(
                  //   child: Image.asset(
                  //     'assets/logo.png',
                  //     height: height * 0.15,
                  //   ),
                  // ),
                  SizedBox(height: fieldSpacing * 2),
                  Text(
                    'Veuillez vous connecter',
                    style: TextStyle(
                      fontSize: 24 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: fieldSpacing * 0.5),
                  Text(
                    'Entrez vos identifiants pour continuer',
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: fieldSpacing * 2),

                  CustomInputField(
                    hintText: 'Email ou votre nom',
                    controller: emailController,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: fieldSpacing),

                  CustomInputField(
                    hintText: 'Mot de passe',
                    obscureText: true,
                    controller: passwordController,
                    validator: Validators.validatePassword,

                  ),
                  SizedBox(height: fieldSpacing * 2),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       // Get.to(() => ForgetPasswordScreen());
                  //     },
                  //     child: Text(
                  //       'Mot de passe oublié?',
                  //       style: TextStyle(
                  //         color: textColorSecond,
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 14 * scaleFactor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: fieldSpacing * 2),
                  Obx(() {
                    if (authController.isLoading.value) {
                      return const Center(
                        child: SpinKitChasingDots(
                          color: btnColor,
                          size: 25,
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: btnColor.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        text: 'Connexion',
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            String email = emailController.text;
                            String password = passwordController.text;
                            authController.login(email, password);
                          }
                        },
                      ),
                    );
                  }),
                  SizedBox(height: fieldSpacing * 3),

                  // DividerWithText(text: 'ou encore',),

                  SizedBox(height: fieldSpacing * 1.8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SocialButton(iconpath: "assets/facebook.png", onPressed: () {}),
                  //     SizedBox(width: width * 0.02),
                  //     SocialButton(iconpath: "assets/Apple.png", onPressed: () {}),
                  //     SizedBox(width: width * 0.02),
                  //     SocialButton(iconpath: "assets/gmail.png", onPressed: () {
                  //     }),
                  //   ],
                  // ),
                  SizedBox(height: height * 0.1),
                  Align(
                    child: RichText(
                      text: TextSpan(
                        text: 'Pas de compte?   ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14 * scaleFactor),
                        children: [
                          TextSpan(
                            text: 's’inscrire',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * scaleFactor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppRoutes.SIGNUP);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
