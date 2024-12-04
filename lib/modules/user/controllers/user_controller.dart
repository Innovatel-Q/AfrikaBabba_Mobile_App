import 'dart:convert';
import 'package:afrika_baba/data/models/user_model.dart';
import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/providers/auth_api_provider.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {

  final  AuthApiProvider apiProvider;

  final AuthController authController = Get.find<AuthController>();
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
  final ImagePicker _picker = ImagePicker();  
  var imagePath = ''.obs;
  var isLoading = false.obs;
  final RxString selectedCountry = "".obs;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  UserController({required this.apiProvider});

  @override
  void onInit() {
    super.onInit();
    _initializeFormValues();
    
    ever(authController.userData, (_) {
      _initializeFormValues();
    });
  }

  void _initializeFormValues() {
    if (authController.userData.value != null) {
      selectedCountry.value = authController.userData.value?.country ?? '';
      addressController.text = authController.userData.value?.address ?? '';
      phoneController.text = authController.userData.value?.phoneNumber ?? '';
    }
  }

  Future<void> selectImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
      
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
              ],
            ),
            WebUiSettings(
              context: Get.context!,
            ),
          ],
        );

        if (croppedFile != null) {
         
          imagePath(croppedFile.path);
          final response = await apiProvider.uploadImage(filepath: croppedFile.path);
         if (response != null) {
           final responseBody = await response.stream.bytesToString();
           localStorage.saveUser(User.fromMap(jsonDecode(responseBody)['data']));
         }
        }
        
      } else {
        // Gérez le cas où aucune image n'est sélectionnée
        Get.snackbar(
          'Sélection d\'image',
          'Aucune image sélectionnée',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Gérez les erreurs éventuelles
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite lors de la sélection de l\'image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editUser(String firstname, String lastname, String phoneNumber) async {
    try {
      isLoading(true);
      final response = await apiProvider.updateUser(firstname, lastname, phoneNumber);
      if (response['data'] != null) {
        final user = User.fromMap(response['data']);
        authController.updateUserData(user);
        Get.back();
        Get.snackbar(
        "Modification réussie", 
        "Vos informations ont été modifiées avec succès",
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
      }
     
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
  Future<void> editAddress(String address, String phone, String country) async {
    try {
      isLoading(true);
      final response = await apiProvider.updateAddress(address, phone, country);
      if (response['data'] != null) {
        final user = User.fromMap(response['data']);
        authController.updateUserData(user);
        Get.back();
        Get.snackbar(
          'Succès',
          'Adresse mise à jour avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier l\'adresse');
    } finally {
      isLoading(false);
    }
  }
  Future<void> resetPassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      isLoading(true);
      final response = await apiProvider.resetPassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword);
      if(response?.statusCode == 403){
         isLoading(false);
        Get.snackbar("Erreur", "l'ancien mot de passe est incorrect", backgroundColor: Colors.red, colorText: Colors.white);
      }
      
      if(response?.statusCode == 200){
         isLoading(false);
        Get.snackbar("Modification réussie", "Votre mot de passe a été modifié avec succès", backgroundColor: Colors.green, colorText: Colors.white);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      print(e);
    }
  }
}
