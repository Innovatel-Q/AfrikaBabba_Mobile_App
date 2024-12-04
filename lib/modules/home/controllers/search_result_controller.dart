import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';


class SearchResultController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  final String query;
  final int? category;

  final RxList<Product> products = <Product>[].obs;
  final ScrollController scrollController = ScrollController();

  final int pageSize = 10; // Nombre d'éléments par page
  int currentPage = 1; // Page actuelle
  bool isLoadingMore = false; // Indicateur de chargement
  bool hasMore = true; // Indicateur de données supplémentaires disponibles

  SearchResultController({required this.query, required this.category});

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Chargement initial des produits
    scrollController.addListener(_onScroll); // Ajoute un écouteur pour le défilement
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Charge les produits
  Future<void> fetchProducts() async {
    if (isLoadingMore || !hasMore) return; // Stop si un chargement est déjà en cours ou s'il n'y a plus de données

    isLoadingMore = true;
    update(); // Met à jour l'interface utilisateur

    try {
      debugPrint('Fetching page $currentPage...');
      final newItems = query.isNotEmpty
          ? await homeController.loadMoreProductsForSearch(query, null, page: currentPage)
          : await homeController.loadMoreProductsForSearch(null, category, page: currentPage);

      debugPrint('Fetched ${newItems.length} items.');

      if (newItems.isEmpty || newItems.length < pageSize) {
        hasMore = false; // Arrête le chargement si plus aucune donnée n'est disponible
      } else {
        currentPage++; // Passe à la page suivante
      }

      products.addAll(newItems); // Ajoute les nouveaux éléments à la liste
    } catch (e) {
      debugPrint('Error fetching products: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les produits.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore = false;
      update(); // Met à jour l'interface utilisateur
    }
  }

  /// Gestion du défilement
  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      fetchProducts(); // Charge plus de produits si le bas est atteint
    }
  }

  /// Recharge les produits
  Future<void> refreshProducts() async {
    currentPage = 1;
    hasMore = true;
    products.clear(); // Vide les produits existants
    update();
    await fetchProducts();
  }
}