import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:afrika_baba/shared/widgets/inputs/custom_input_field_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:country_picker/country_picker.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});
  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
   final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();


  // Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {

    addressController.text =  authController.userData.value!.address ?? '';
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
          "Nouvelle adresse",
          style: GoogleFonts.poppins(
            fontSize: 18,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // GestureDetector(
                //   onTap: () {
                //     showCountryPicker(
                //       context: context,
                //       showPhoneCode: false, 
                //       onSelect: (Country country) {
                //         setState(() {
                //           _selectedCountry = country;
                //         });
                //       },
                //     );
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(color: Colors.grey),
                    
                //     ),
                //     child: Row(
                //       children: [
                //         if (_selectedCountry != null)
                //           Text(
                //             '${_selectedCountry!.flagEmoji} ${_selectedCountry!.name}',
                //             style: GoogleFonts.poppins(
                //               fontSize: 16,
                //               color: Colors.black87,
                //             ),
                //           )
                //         else
                //           Text(
                //             'Sélectionner votre pays',
                //             style: GoogleFonts.poppins(
                //               fontSize: 16,
                //               color: Colors.grey,
                //             ),
                //           ),
                //         const Spacer(),
                //         const Icon(Icons.arrow_drop_down, color: Colors.grey),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                CustomInputFieldWithLabel(hintText: 'Adresse', label: 'Adresse', controller: addressController),
                const SizedBox(height: 20),
                CustomInputFieldWithLabel(hintText: 'Numero mobile', label: 'Numero mobile', controller: phoneController),
                const SizedBox(height: 30),
                Obx((){
                  if (userController.isLoading.value) {
                    return   const Center(child: SpinKitFadingCircle(
                      color: btnColor,
                      size: 50.0,
                    ));
                  }
                  return CustomButton(
                    text: 'Sauvegarder les changements',
                  color: btnColorSecond,
                  size: 13,
                  onPressed: () {
                    if(addressController.text.isEmpty || phoneController.text.isEmpty){
                      Get.snackbar('Erreur', 'Veuillez remplir tous les ch  amps', backgroundColor: Colors.red, colorText: Colors.white);
                    }else{
                      userController.editAddress(addressController.text, phoneController.text);
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
