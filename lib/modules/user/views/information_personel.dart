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

class InformationPersonel extends GetView<AuthController> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  InformationPersonel({super.key});

  @override
  Widget build(BuildContext context) {
    firstnameController.text = controller.userData.value?.firstname ?? '';
    lastnameController.text = controller.userData.value?.lastname ?? '';
    emailController.text = controller.userData.value?.email ?? '';
    phoneController.text = controller.userData.value?.phoneNumber ?? '';
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
      backgroundColor: backgroundAppColor,
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
                  CustomInputFieldWithLabel(hintText: 'Prenom', label: 'Prenom', controller: lastnameController,validator:Validators.validateRequired),
                  const SizedBox(height: 20),
                  CustomInputFieldWithLabel(hintText: 'Numéro mobile', label: 'Numéro mobile', controller: phoneController,validator:Validators.validatePhoneNumber),
                  const SizedBox(height: 30),
                  Obx((){ 
                    if (userController.isLoading.value) {
                      return  const Center(child:SpinKitChasingDots(
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