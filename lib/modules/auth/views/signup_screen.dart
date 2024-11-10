import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/CustomInputField.dart';
import 'package:afrika_baba/shared/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedCountry = 'CIV';

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35,),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Créons votre\ncompte',
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      height: 1.2,
                      color: btnColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Veuillez saisir les informations\ncomplètes ci-dessous',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomInputField(
                    hintText: 'Nom',
                    controller: firstnameController,
                    validator: Validators.validateRequired, 
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'Prenom',
                    controller: lastnameController,
                    validator: Validators.validateRequired, 
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: Validators.validateEmail, 
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'Mot de passe',
                    controller: passwordController,
                    obscureText: true,
                    validator: Validators.validatePassword, 
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'CIV',
                              child: Text('🇨🇮 +225', style: TextStyle(fontSize: 20)),
                            ),
                            DropdownMenuItem(
                              value: 'SN',
                              child: Text('🇸🇳 +221', style: TextStyle(fontSize: 20)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value!;
                            });
                          },
                          value: selectedCountry,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomInputField(    
                          hintText: 'Numéro mobile',
                          controller: phoneController,
                          validator: Validators.validatePhoneNumber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Obx(() {
                    if (authController.isLoading.value) {
                      return const Center(child: SpinKitWave(
                        color: btnColor,
                        size: 25,
                      ));
                    }
                    return CustomButton(
                      text: 'S\'inscrire',
                      color: btnColorSecond,
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          String firstname = firstnameController.text;
                          String lastname = lastnameController.text;
                          String phoneNumber = phoneController.text;
                          String email = emailController.text;
                          String password = passwordController.text;
                          String passwordConfirmation = passwordController.text;
                          authController.signup(firstname, lastname, phoneNumber, email, password, passwordConfirmation, "CUSTOMER", selectedCountry);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (authController.authError.isNotEmpty) {
                      return Text(
                        authController.authError.value,
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return Container();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
