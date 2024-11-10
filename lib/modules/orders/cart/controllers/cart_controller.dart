import 'package:afrika_baba/data/models/cart_model.dart' ;
import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {

  // ignore: non_constant_identifier_n evitez sames
  RxList<CartModel> product_cart = RxList<CartModel>();
  final LocalStorageProvider localStorageProvider = LocalStorageProvider();
  RxInt totalProduct = 0.obs;
  RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
    updateTotals();
  }

  void loadCartFromStorage() {
    List<CartModel> cartHistory = localStorageProvider.getCartHistory();
    product_cart.value = cartHistory;
    updateTotals();
  }


  void addProduct(Product product) {
    if (product_cart.any((element) => element.product.id == product.id)) {
      Get.snackbar(
        'Produit déjà dans le panier',
        'Le produit ${product.name} est déjà dans votre panier',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      product_cart.add(CartModel(id: product.id, product: product, quantity: 1.obs));
      localStorageProvider.saveCartHistory(product_cart);
      updateTotals();
      Get.snackbar(
        'Produit ajouté',
        'Le produit ${product.name} a été ajouté à votre panier',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
   
  }

  void removeProduct(CartModel cartItem) {
    product_cart.remove(cartItem);
    localStorageProvider.saveCartHistory(product_cart);
    updateTotals();
  }

  void incrementProduct(Product product) {
    var cartItem = product_cart.firstWhere((element) => element.product.id == product.id);
    cartItem.quantity++;
    localStorageProvider.saveCartHistory(product_cart);
    updateTotals();
  }

  void decrementProduct(Product product) {
    var cartItem = product_cart.firstWhere((element) => element.product.id == product.id);
    if (cartItem.quantity.value > 1) {
      cartItem.quantity--;
      localStorageProvider.saveCartHistory(product_cart);
      updateTotals();
    }
  }

  void clearCart() {
    product_cart.clear();
    localStorageProvider.clearCartHistory();
    updateTotals();
  }

  void updateTotals() {
    totalProduct.value = product_cart.length;
    double total = product_cart.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity.value));
    totalPrice.value = double.parse(total.toStringAsFixed(2));
    update();
  }
}