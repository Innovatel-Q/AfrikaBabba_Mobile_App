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
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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


    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: backgroundAppColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = screenSize.width * 0.06;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: screenSize.height * 0.02,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32,),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Text(
                        'Créons votre\ncompte',
                        style: GoogleFonts.poppins(
                          fontSize: screenSize.width * 0.06,
                          height: 1.2,
                          color: btnColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        'Veuillez saisir les informations\ncomplètes ci-dessous',
                        style: GoogleFonts.poppins(
                          fontSize: screenSize.width * 0.04, // Taille de police adaptative
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Ajuster les espacements entre les champs
                      SizedBox(height: screenSize.height * 0.025),
                      // Wrapper les champs de saisie dans un Container avec contraintes
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 600, // Largeur maximale sur les grands écrans
                        ),
                        child: Column(
                          children: [
                            CustomInputField(
                              hintText: 'Nom',
                              controller: firstnameController,
                              validator: Validators.validateRequired,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            CustomInputField(
                              hintText: 'Prenom',
                              controller: lastnameController,
                              validator: Validators.validateRequired, 
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            CustomInputField(
                              hintText: 'Email',
                              controller: emailController,
                              validator: Validators.validateEmail, 
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            CustomInputField(
                              hintText: 'Mot de passe',
                              controller: passwordController,
                              obscureText: true,
                              validator: Validators.validatePassword, 
                            ),
                            SizedBox(height: screenSize.height * 0.02),
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
                            SizedBox(height: screenSize.height * 0.04),
                          ],
                        ),
                      ),

                      // Ajuster l'espacement avant le bouton
                      // SizedBox(height: screenSize.height * 0.01),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          width: double.infinity,
                          child: Obx(() {
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
                        ),
                      ),

                      SizedBox(height: screenSize.height * 0.02),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
