import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/views/detail_product.dart';
import 'package:afrika_baba/modules/home/views/seach_result_page.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/providers/product_api_provider.dart'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ProductApiProvider productApiProvider;
  RxList<Product> products = <Product>[].obs;
  RxList<Category> categories = <Category>[].obs;
  RxList<Product> productsPaginated = <Product>[].obs;
  RxList<String> searchSuggestions = <String>[].obs;
  RxList<String> searchHistory = RxList<String>();
  RxList<Review> reviews = <Review>[].obs;
  late TextEditingController value;
  RxString searchQuery = ''.obs;
  final RxBool initialLoading = true.obs;
  final RxBool isLoading = false.obs;

  HomeController({required this.productApiProvider});

  @override
  void onInit() {
    super.onInit();
    value = TextEditingController();
    value.addListener(_onValueChanged);
    getProducts();
    getCategories();
  }


  Future<String?> getProductImageById(int productId) async
  {
    final response = await productApiProvider.getProductById(productId);
    if (response?.statusCode == 200 && response?.data != null) {
      return Product.fromJson(response?.data['data']).mainImageUrl;
    } else {
      print('Erreur lors de la récupération du produit : ${response?.statusCode}');
      return null;
    }
  }

  void _onValueChanged() {
    searchQuery.value = value.text;
    update();
  }

  void getProductReviews(int productId) {
    reviews.value = products.firstWhere((p) => p.id == productId).reviews;
  }

  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      initialLoading.value = true;
      final response = await productApiProvider.getProducts(page: 1);
      if (response?.statusCode == 200 && response?.data != null) {
        products.clear();
        products.addAll((response?.data['data'] as List)
            .map((element) => Product.fromJson(element)));
        print('Produits récupérés avec succès ${products.length}');
      } else {
        print('Erreur : ${response?.statusCode}');
      }
    } catch (e) {
      print("Erreur lors de la récupération des produits : $e");
    } finally {
      isLoading.value = false;
      initialLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await productApiProvider.getCategories(page: 1);
      if (response?.statusCode == 200 && response?.data != null) {
        categories.addAll((response?.data['data'] as List)
            .map((element) => Category.fromJson(element)));
      }
    } catch (e) {
      print("Erreur lors de la récupération des catégories : $e");
    }
  }

  Future<List<Product>> loadMoreProducts({int page = 1}) async {
    try {
      isLoading.value = true;
      final response = await productApiProvider.getProducts(page: page);
      if (response?.statusCode == 200 && response?.data != null) {
        List<Product> newProducts = (response?.data['data'] as List)
            .map((element) => Product.fromJson(element))
            .toList();
        return newProducts;
      }
      return [];
    } catch (e) {
      print("Erreur lors du chargement des produits : $e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Product>> loadMoreProductsForSearch(String? name, int? category, {int page = 1}) async {
    try {
      isLoading.value = true;
      final response =
          await productApiProvider.searchProduct(name, category, page: page);
      if (response?.statusCode == 200 && response?.data != null) {
        List<Product> newProducts = (response?.data['data'] as List)
            .map((element) => Product.fromJson(element))
            .toList();
        return newProducts;
      }
    } catch (e) {
      print("Erreur lors du chargement des produits : $e");
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  void onSearchChanged(String query) async {
    if (query.length > 2) {
      final response =
          await productApiProvider.serachAutoCompleteProduct(query);
      if (response?.statusCode == 200 && response?.data != null) {
        searchSuggestions.clear();
        searchSuggestions.addAll(
            (response?.data as List).map((element) => element.toString()));
      }
    }
  }


  void performSearch(String query, {int page = 1}) async {
    final response = await productApiProvider.searchProduct(query, null, page: page);
    if (response?.statusCode == 200 && response?.data != null) {
      saveSearchHistory(query);
      productsPaginated.clear();
      productsPaginated.addAll((response?.data['data'] as List)
          .map((element) => Product.fromJson(element)));
      Get.to(() => SearchResultPage(query: query, category: null));
    }
  }

  void performSearchByCategory(String? query, int? category) async {
    productsPaginated.clear();
    final response = await productApiProvider.searchProduct(query, category);
    if (response?.statusCode == 200 && response?.data != null) {
      productsPaginated.clear();
      productsPaginated.addAll((response?.data['data'] as List)
          .map((element) => Product.fromJson(element)));
      Get.to(() => SearchResultPage(query: query ?? '', category: category));
    }
  }

  void saveSearchHistory(String query) {
    if (query.isNotEmpty) {
      final LocalStorageProvider storage = Get.find<LocalStorageProvider>();
      searchHistory.remove(query);
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory.removeLast();
      }
      storage.saveSearchHistory(searchHistory.toList());
    }
  }

  void loadSearchHistory() {
    final LocalStorageProvider storage = Get.find<LocalStorageProvider>();
    searchHistory.value = storage.getSearchHistory();
  }

  void clearSearchHistory() {
    final LocalStorageProvider storage = Get.find<LocalStorageProvider>();
    storage.clearSearchHistory();
    searchHistory.clear();
  }

  void removeFromSearchHistory(String query) {
    final LocalStorageProvider storage = Get.find<LocalStorageProvider>();
    searchHistory.remove(query);
    storage.saveSearchHistory(searchHistory.toList());
  }

  Future<void> addComment(int productId, Map<String, dynamic> data) async {
  
  final response = await productApiProvider.addComment(data);

  if (response != null && response.statusCode == 201) {

    var responseData = response.data['data'];
    if (responseData != null) {
   
      var product = products.firstWhere((element) => element.id == productId);
      product.reviews.add(Review.fromJson(responseData));

      Get.snackbar(
        'Commentaire ajouté', 
        'Merci pour votre commentaire',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => DetailProduct(product: product));
    } else {
      print('Données de réponse invalides');
    }
  } else {
    print('Erreur lors de l\'ajout du commentaire');
  }
}

  Future<void> editComment(int commentId, Map<String, dynamic> data) async {
    final response = await productApiProvider.editComment(commentId, data);
    if (response != null && response.statusCode == 200) {
    } else {
      print('Erreur lors de la modification du commentaire');
    }
  }

  Future<void> deleteComment(int commentId, int productId) async {
    final response = await productApiProvider.deleteComment(commentId);
    if (response?.statusCode == 204){
      var product = products.firstWhere((element) => element.id == productId);
      product.reviews.removeWhere((element) => element.id == commentId);
      reviews.removeWhere((element) => element.id == commentId);
    } else {
      print('Erreur lors de la suppression du commentaire');
    }
  }
  
  
  @override
  void onClose() {
    value.dispose();
    super.onClose();
  }
}
