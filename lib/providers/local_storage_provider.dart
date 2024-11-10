import 'package:afrika_baba/data/models/cart_model.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../data/models/user_model.dart';

class LocalStorageProvider {
  // Initialisation du GetStorage
  final _storage = GetStorage();

  final String _tokenKey = 'auth_token';
  final String _userKey = 'user';
  final String _isFirstLaunchKey = 'is_first_launch_app';
  final String _emailKey = 'email';
  final String _cartHistoryKey = 'cart_history';

  // Sauvegarder le token d'authentification
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // Récupérer le token d'authentification
  String? getToken() {
    return _storage.read(_tokenKey);
  }

  // Supprimer le token d'authentification
  Future<void> removeToken() async {
    await _storage.remove(_tokenKey);
  }

  // Sauvegarder les informations utilisateur (sous forme de Map)
  Future<void> saveUser(User user) async {
    await _storage.write(_userKey, user.toMap());
  }

  // Récupérer les informations utilisateur
  User? getUser() {
    final userMap = _storage.read(_userKey) as Map<String, dynamic>?;
    return userMap != null ? User.fromMap(userMap) : null;
  }

  // Supprimer les informations utilisateur
  Future<void> removeUser() async {
    await _storage.remove(_userKey);
  }

  // Vérifier si c'est la première fois de lancer l'application
  bool isFirstLaunch() {
    return _storage.read(_isFirstLaunchKey) ??
        true; // Renvoie true si la clé n'existe pas encore
  }

// Marquer que l'application a déjà été lancée
  Future<void> completeFirstLaunch() async {
    await _storage.write(
        _isFirstLaunchKey, false); // Écrire false après la première ouverture
  }

  Future<void> saveEmail(String email) async {
    await _storage.write(_emailKey, email);
  }

  Future<void> clearStorage() async {
    await _storage.erase();
  }

  Future<void> saveSearchHistory(List<String> searchHistory) async {
    await _storage.write('search_history', searchHistory);
  }

  List<String> getSearchHistory() {
    final dynamic rawHistory = _storage.read('search_history');
    if (rawHistory is List) {
      return rawHistory.map((item) => item.toString()).toList();
    }
    return [];
  }

  Future<void> clearSearchHistory() async {
    await _storage.remove('search_history');
  }

  Future<void> saveCartHistory(List<CartModel> cartHistory) async {
    final List<Map<String, dynamic>> encodableList =
        cartHistory.map((item) => item.toJson()).toList();
    final String encodedCartHistory = json.encode(encodableList);
    await _storage.write(_cartHistoryKey, encodedCartHistory);
  }

  List<CartModel> getCartHistory() {
    final String? encodedCartHistory = _storage.read(_cartHistoryKey);
    if (encodedCartHistory != null) {
      return (json.decode(encodedCartHistory) as List)
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> removeCartItem(int id) async {
    final List<CartModel> cartHistory = getCartHistory();
    final List<CartModel> updatedCartHistory =
        cartHistory.where((item) => item.id != id).toList();
    await saveCartHistory(updatedCartHistory);
  }

  Future<void> clearCartHistory() async {
    await _storage.remove(_cartHistoryKey);
  }
}
