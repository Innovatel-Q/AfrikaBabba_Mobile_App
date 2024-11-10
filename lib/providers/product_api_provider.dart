
import 'package:afrika_baba/providers/api_provider.dart';

import 'package:dio/dio.dart';
// import 'package:get/get.dart' as;



class ProductApiProvider {
  
  final  ApiProvider apiProvider =  ApiProvider();

  // final LocalStorageProvider localStorage = get.Get.find<LocalStorageProvider>();

  Future<Response?> getProducts({int page = 1}) async {
    try {
      final response = await apiProvider.dio.get("/products?page=$page");
       return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits : $e');
    }
  }

  Future<Response?> getProductById(int productId) async {
    try {
      final response = await apiProvider.dio.get("/products/$productId");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du produit : $e');
    }
  }

  getComments(int productId) async {
    try {
      final response = await apiProvider.dio.get("/reviews");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des commentaires : $e');
    }
  } 



  Future<Response?>addComment(Map<String, dynamic> data) async {
    try {
      final response = await apiProvider.dio.post("/reviews", data: data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du commentaire : $e');
    }
  }

  Future<Response?> editComment(int commentId, Map<String, dynamic> data) async {
    try {
      final response = await apiProvider.dio.post("reviews/update/$commentId", data: data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la modification du commentaire : $e');
    }
  }

  Future<Response?> deleteComment(int commentId) async {
    try {
      final response = await apiProvider.dio.delete("/reviews/$commentId");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la suppression du commentaire : $e');
    }
  }

  // get all categories
  Future<Response?> getCategories({int page = 1}) async {
    try {
      final response = await apiProvider.dio.get("/categories?page=$page");
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des catégories : $e');
    }
  }

  serachAutoCompleteProduct(String query) async {
    try {
      final response = await apiProvider.dio.post("/products/auto", data: {"query": query});
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la recherche des produits : $e');
    }
  }

  Future<Response?> searchProduct(String? name, int? category, {int page = 1}) async {
    try {
      Map<String, dynamic> data = {};
      if (category != null) {
        data['category_id'] = category;
      } else {
        data['name'] = name;
      }
      final response = await apiProvider.dio.get("/products?page=$page", queryParameters: data);
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des produits par catégorie ou par nom : $e');
    }
  }
}
