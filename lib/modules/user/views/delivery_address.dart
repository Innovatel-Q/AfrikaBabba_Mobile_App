import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/custom_input_field_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryAddressScreen extends GetView<UserController> {

  DeliveryAddressScreen({super.key});

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  final List<String> countryAvailableList = ["CIV","SN"];
  final RxString selectedCountry = "".obs;

  @override
  Widget build(BuildContext context) {

    selectedCountry.value = authController.userData.value?.country ?? '';
    addressController.text = authController.userData.value!.address ?? '';
    phoneController.text = authController.userData.value?.phoneNumber ?? '';
    countryController.text = authController.userData.value?.country ?? '';

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
          "Nouvelle adresse",
          style: GoogleFonts.poppins(
            fontSize: 18,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CustomInputFieldWithLabel(hintText: 'Adresse', label: 'Adresse', controller: addressController),
                const SizedBox(height: 20),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedCountry.value.isEmpty ? null : selectedCountry.value,
                    decoration: const InputDecoration(
                      labelText: 'Code pays',
                      border: InputBorder.none,
                    ),
                    items: countryAvailableList.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedCountry.value = newValue ?? '';
                      countryController.text = newValue ?? '';
                    },
                  ),
                )),
                const SizedBox(height: 20),
                CustomInputFieldWithLabel(hintText: 'Numero mobile', label: 'Numero mobile', controller: phoneController),
                const SizedBox(height: 30),
                Obx((){
                  if (controller.isLoading.value) {
                    return   const Center(child: SpinKitChasingDots(
                      color: btnColor,
                      size: 50.0,
                    ));
                  }
                  return CustomButton(
                    text: 'Sauvegarder les changements',
                  color: btnColorSecond,
                  size: 13,
                  onPressed: () {
                    if(addressController.text.isEmpty || phoneController.text.isEmpty || countryController.text.isEmpty){
                      Get.snackbar('Opps', 'Veuillez remplir tous les champs', backgroundColor: Colors.red, colorText: Colors.white);
                    }else{
                      if(!countryAvailableList.contains(countryController.text)){
                        Get.snackbar('Opps', 'Veuillez saisir une code de pays valide (SN,CIV)', backgroundColor: Colors.red, colorText: Colors.white);
                        return;
                      }
                      controller.editAddress(addressController.text, phoneController.text,countryController.text);
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
    );
  }
}
