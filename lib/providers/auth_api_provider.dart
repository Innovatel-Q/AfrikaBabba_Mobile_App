import 'dart:convert';
import 'package:afrika_baba/providers/api_provider.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;

class AuthApiProvider {
  final ApiProvider apiProvider = ApiProvider();
  final String baseUrl = 'https://afrikababaa-571dedf1e98c.herokuapp.com/api';

  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();

  Future<Response?> login(String email, String password) async {
    try {
      final response = await apiProvider.dio.post("/auth/login", data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Erreur lors de la connexion : ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar('Connexion', 'Email ou mot de passe incorrect',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Erreur', 'Une erreur est survenue lors de la connexion',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
      return null;
    }
  }

  Future<Response?> signup(
      String firstname,
      String lastname,
      String phoneNumber,
      String email,
      String password,
      String passwordConfirmation,
      String role,
      String country) async {
    Map<String, dynamic> data = {
      "firstname": firstname,
      "lastname": lastname,
      "phone_number": phoneNumber,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "role": role,
      "country": country,
    };
    try {
      final response = await apiProvider.dio.post("/auth/register", data: data);
      if (response.statusCode == 201) {
        return response;  
      } else {
        throw Exception(
            'Erreur lors de la création de l\'utilisateur : ${response.data}');
      }
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.statusCode);
      if (e.response?.statusCode == 400) {
        if (e.response?.data is String) {
          try {
            final errorData = json.decode(e.response?.data as String) as Map<String, dynamic>;
            final errorMessages = <String>[];
            
            if (errorData.containsKey('phone_number')) {
              errorMessages.add('ce numéro de téléphone est déjà utilisé');
            }
            if (errorData.containsKey('email')) {
              errorMessages.add("cet email est déjà utilisé");
            }
            
            final errorMessage = errorMessages.join('\n');
            
            Get.snackbar(
              'Erreur',
              errorMessage,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
          } catch (jsonError) {
            print('Erreur lors du parsing JSON: $jsonError');
            Get.snackbar(
              'Erreur',
              'Une erreur est survenue lors de l\'inscription',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Erreur',
            'Une erreur inattendue est survenue',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String firstname, String lastname, String phoneNumber) async {
    final response = await apiProvider.dio
        .post("/users/update/${localStorage.getUser()?.id}", data: {
      "firstname": firstname,
      "lastname": lastname,
      "phone_number": phoneNumber,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          'Erreur lors de la modification de l\'utilisateur : ${response.data}');
    }
  }

  Future<Map<String, dynamic>> updateAddress(String address, String phoneNumber) async {
    final response = await apiProvider.dio.post("/users/update/${localStorage.getUser()?.id}", data: {
      "adresse": address,
      "phone_number": phoneNumber,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          'Erreur lors de la modification de l\'utilisateur : ${response.data}');
    }
  }

  

  Future<http.StreamedResponse?> uploadImage({required String filepath}) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('$baseUrl/users/update/${localStorage.getUser()?.id}'))
        ..headers.addAll({
          'Authorization': 'Bearer ${localStorage.getToken()}',
        })
        ..files.add(await http.MultipartFile.fromPath('avatar', filepath));

      var response = await request.send();

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print(response.toString());
        }
        return response;
      } else {
        final responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          if (response.statusCode == 422) {
            final jsonResponse = json.decode(responseBody);
            if (jsonResponse['errors']['avatar'] != null) {
              Get.snackbar("Erreur", jsonResponse['errors']['avatar'][0],
                  backgroundColor: Colors.red, colorText: Colors.white);
            }
          }
        }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final response = await apiProvider.dio.post("/logout");
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la déconnexion : ${response.data}');
    }
  }

  Future<Response?> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiProvider.dio.post(
        "/password/change",
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );
      return response; // Retourne la réponse en cas de succès
    } on DioException catch (e) {
      // Gestion spécifique des erreurs Dio
      if (e.response != null) {
        print(
            'Erreur de réponse Dio: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('Erreur Dio sans réponse : ${e.message}');
      }
      return e
          .response; // Retourne la réponse pour que l'appelant puisse la gérer
    } catch (e) {
      // Gestion des autres erreurs
      print('Erreur inattendue : $e');
      return null; // Retourne null en cas d'erreur inattendue
    }
  }
}
