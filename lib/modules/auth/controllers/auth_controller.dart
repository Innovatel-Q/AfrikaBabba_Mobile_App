import 'package:afrika_baba/data/models/user_model.dart' as AppUser;
import 'package:afrika_baba/providers/auth_api_provider.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  final AuthApiProvider authApiProvider;
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var authError = ''.obs;
  var userData = Rx<AppUser.User?>(null);

  AuthController({required this.authApiProvider});

  @override
  void onInit() {
    final user = localStorage.getUser();
    if (user != null) {
      userData(user);
      isLoggedIn(true);
    }
    super.onInit();
  }

  Future<void> login(String email, String password) async {
      isLoading(true);
      authError('');
      final response = await authApiProvider.login(email, password);
      if(response != null){
        localStorage.saveToken(response.data['access_token']);
        final user = AppUser.User.fromMap(response.data['user']);
        userData(user);
        localStorage.saveUser(user);
        Get.offAllNamed('/home');
      }  
      isLoading(false);
  }


  Future<void> signup(
      String firstname,
      String lastname,
      String phoneNumber,
      String email,
      String password,
      String passwordConfirmation,
      String role,
      String country
      ) async {

    isLoading(true);
    authError('');
    final reponse =  await authApiProvider.signup(firstname, lastname, phoneNumber, email,
        password, passwordConfirmation, role, country);
    if (reponse != null) {
      Get.snackbar('Succès', 'Merci de valider votre email', backgroundColor: Colors.green, colorText: Colors.white,duration: const Duration(seconds: 3));
      Get.offAllNamed('/firstlogin');
    }
    isLoading(false);
  }


  Future<void> logout() async {
    try {
      isLoading(true);
      await authApiProvider.logout();
      localStorage.removeUser();
      localStorage.removeToken();
      isLoggedIn(false);
      userData(null);
      Get.offAllNamed('/firstlogin');
    } catch (e) {
      Get.snackbar('Erreur de déconnexion',
          'Impossible de se déconnecter.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}
