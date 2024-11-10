
import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/utils/validators.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/custom_input_field_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationPersonel extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  InformationPersonel({super.key});

  @override
  Widget build(BuildContext context) {
    firstnameController.text = authController.userData.value?.firstname ?? '';
    lastnameController.text = authController.userData.value?.lastname ?? '';
    emailController.text = authController.userData.value?.email ?? '';
    phoneController.text = authController.userData.value?.phoneNumber ?? '';
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); 
          },
        ),
        title: Text(
          "Informations personnelles",
          style: GoogleFonts.poppins(
            fontSize: 18 ,
            fontWeight: FontWeight.bold,
            color: btnColor,
          ),
        ),
        centerTitle: true,
      ),
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
                  const SizedBox(height: 30),
                  CustomInputFieldWithLabel(hintText: 'Nom', label: 'Nom', controller: firstnameController,validator:Validators.validateRequired),
                  const SizedBox(height: 20),
                  CustomInputFieldWithLabel(hintText: 'Prenom', label: 'Nom', controller: lastnameController,validator:Validators.validateRequired),
                  const SizedBox(height: 20),
                 
                  const SizedBox(height: 20),
                  CustomInputFieldWithLabel(hintText: 'Numéro mobile', label: 'Numéro mobile', controller: phoneController,validator:Validators.validatePhoneNumber),
                  const SizedBox(height: 30),
                  Obx((){ 
                    if (userController.isLoading.value) {
                      return  const Center(child: SpinKitFadingCircle(
                        color: btnColor,
                        size: 50.0,
                      ));
                    }
                    return CustomButton(
                      text: 'Sauvegarder les changements',
                    color: btnColorSecond,
                    size: 13,
                    onPressed: () {
                     if (_formKey.currentState!.validate()) {
                        userController.editUser(firstnameController.text, lastnameController.text, phoneController.text);
                      }
                    },
                  );
                },
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