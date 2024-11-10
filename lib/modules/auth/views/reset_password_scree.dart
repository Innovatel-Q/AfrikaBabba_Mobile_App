import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/utils/validators.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>(); 
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController
  ();
 
  @override
    Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                    'Modifier votre\nmot de passe',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Changed from screenHeight to screenWidth
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                
                  CustomInputField(
                    hintText: 'Ancien mot de passe',
                    controller: oldPasswordController,
                    validator: Validators.validatePassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'Nouveau mot de passe',
                    controller: passwordController,
                    validator: Validators.validatePassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                 CustomInputField(
                    hintText: 'Confirmer nouveau mot de passe',
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (confirmPassword) => Validators.validateConfirmPassword(passwordController.text, confirmPassword),
                  ),  
                  SizedBox(height: screenHeight * 0.08),
                  Obx((){
                    if (userController.isLoading.value) {
                      return  const Center(child: SpinKitFadingCircle(
                        color: btnColor,
                        size: 50.0,
                      ));
                    }
                    return CustomButton(
                      text: 'Modifier',
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          String oldPassword = oldPasswordController.text;
                          String newPassword = passwordController.text;
                          String confirmPassword = confirmPasswordController.text;
                          userController.resetPassword(oldPassword, newPassword, confirmPassword);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 30),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}