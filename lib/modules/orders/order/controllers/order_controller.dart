import 'package:afrika_baba/data/models/Delivery_cost_model.dart';
import 'package:afrika_baba/data/models/delivey_batch_model.dart';
import 'package:afrika_baba/data/models/my_order_response.dart';
import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/providers/order_api_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  
  OrderApiProvider orderApiProvider;
  
  RxList<Order> myOrdersPending = <Order>[].obs;
  RxList<Order> myOrdersDelivered = <Order>[].obs;
  RxList<Order> myOrdersRejected = <Order>[].obs;
  RxList<Order> myOrdersCanceled = <Order>[].obs;
  RxList<Order> myOrdersInProgress = <Order>[].obs;
  RxList<Order> myOrdersViews = <Order>[].obs;
  final RxBool isLoadingCreate = false.obs;
  Rx<String> selectedFilter = ''.obs;


  // ignore: constant_identifier_names
  static const int DELIVERY_MODE_AIR = 1;
  // ignore: constant_identifier_names
  static const int DELIVERY_MODE_SEA = 2;

  Rx<DeliveryBatchesResponse?> deliveryBatchesResponse = Rx<DeliveryBatchesResponse?>(null);
  Rx<DeliveryCostModel?> deliveryCostModel = Rx<DeliveryCostModel?>(null);
  final CartController cartController = Get.find<CartController>();
  final LocalStorageProvider localStorageProvider = Get.find<LocalStorageProvider>();

  Rx<double> totalOrder = 0.0.obs;
  Rx<double> totalDeliveryCost = 0.0.obs;
  Rx<int> deliveryMode = DELIVERY_MODE_SEA.obs;

  List<Order> get myOrders {
    return [
      ...myOrdersPending,
      ...myOrdersDelivered,
      ...myOrdersRejected,
      ...myOrdersCanceled,
      ...myOrdersInProgress
    ];
  }
  
  @override
  void onInit() {
    super.onInit();
    getMyOrders();
    initializeOrderTotals();
    updateTotalOrder(1);
    getDeliveryCost();
    getTotalWeight();
  }

  OrderController({required this.orderApiProvider});

  Future<void> getDeliveryCost() async {
    try {
      final response = await orderApiProvider.getDeliveryCost();
      if (response != null && response.data['data'] is List) {
        final List<dynamic> dataList = response.data['data'];
        if (dataList.isNotEmpty) {
          deliveryCostModel.value = DeliveryCostModel.fromJson(dataList.first);
        } else {
          print('Delivery cost data is empty');
        }
      } else {
        print('Unexpected response format for delivery cost');
      }
    } catch (e) {
      print('Error fetching delivery cost: $e');
    }
  }

  double getTotalCostOrder() {
    try {
      return cartController.product_cart.fold(
        0.0,
        (sum, element) {
          double fraisInternes = 0.0;
          try {
            fraisInternes = double.parse(element.product.shop.fraisInterne);
          } catch (e) {
            print('Erreur de conversion des frais internes: ${e.toString()}');
          }

          return sum + ((element.product.productWeight * element.quantity.value) * fraisInternes);
        }
      );
    } catch (e) {
      print('Erreur dans le calcul du coût total: ${e.toString()}');
      return 0.0;
    }
  }
  
  double getTotalPrice() {

    return cartController.product_cart.fold(
        0.0,
        (sum, element) =>
            sum + (element.product.price * element.quantity.value));
  }
  
  double getTotalWeight() {
    return cartController.product_cart.fold(
        0.0,
        (sum, element) {
          double productWeight = element.product.productWeight;
          int quantity = element.quantity.value;
          double subTotal = productWeight * quantity;  
          return sum + subTotal;
        });
  }

  void updateTotalOrder(int mode) {
    if (deliveryCostModel.value == null) {
      return;
    }
    deliveryMode.value = mode;
    totalDeliveryCost.value = getTotalWeight() * 
      (mode == DELIVERY_MODE_AIR ? 
        deliveryCostModel.value?.costAir ?? 0 : 
        deliveryCostModel.value?.costSea ?? 0);
    totalOrder.value = (getTotalCostOrder() + getTotalPrice()).toDouble();
  }

  Future<void> createOrder() async {
    try {
      final orderItems = cartController.product_cart.map((e) => {
            'product_id': e.product.id,
            'quantity': e.quantity.value,
            'price': e.product.price,
            'frais_interne': e.product.productWeight * e.quantity.value * double.parse(e.product.shop.fraisInterne)
        }).toList();
      isLoadingCreate.value = true;
      final finalTotalAmount = totalOrder.value + totalDeliveryCost.value;
      final response = await orderApiProvider.createOrder(
        deliveryMethod: deliveryMode.value.toString() == "1" ? "AIR" : "SEA",
        deliveryCost: totalDeliveryCost.value.toString(),
        totalPrice: finalTotalAmount.toString(),
        orderItems: orderItems
      );
      if (response?.data != null) {
        getMyOrders();
        isLoadingCreate.value = false;
        Get.toNamed(AppRoutes.PAYMENT_CONFIRMATION_SCREEN);
        cartController.clearCart();
      } else {
        print('Unexpected response format for order creation');
      }
      isLoadingCreate.value = false;
    } catch (e) {
      Get.snackbar('Oups!', 'Une erreur est survenue lors de la création de votre commande, veuillez réessayer plus tard.', 
      colorText: Colors.white,
      backgroundColor: Colors.red);
      print('Error creating order: $e.toString()');
      isLoadingCreate.value = false;
    }
  }

  Future<void> getMyOrders({int page = 1}) async {
    try {
      // Vide toutes les listes existantes
      // Clears all existing lists
      myOrdersPending.clear();
      myOrdersDelivered.clear();
      myOrdersRejected.clear();
      myOrdersCanceled.clear();
      myOrdersInProgress.clear();

      // Fait l'appel API pour récupérer les commandes
      // Makes API call to fetch orders

      final response = await orderApiProvider.getMyOrders(page: page);
      
      if (response?.statusCode == 200 && response?.data != null) {

        // Convertit la réponse en objet MyOrderResponse
        // Converts response to MyOrderResponse object

        MyOrderResponse myOrderResponse = MyOrderResponse.fromJson(response?.data); 

        // Trie les commandes selon leur statut
        // Sorts orders by their status

        myOrdersPending.addAll(myOrderResponse.orders.where(
          (order) => order.status == 'PENDING' && order.deletedAt == null
        ));
        myOrdersDelivered.addAll(myOrderResponse.orders.where(
          (order) => order.status == 'DELIVERED' && order.deletedAt == null
        ));
        myOrdersRejected.addAll(myOrderResponse.orders.where(
          (order) => order.status == 'REJECTED' && order.deletedAt == null
        ));
        myOrdersCanceled.addAll(myOrderResponse.orders.where(
          (order) => order.status == 'CANCELED' && order.deletedAt == null
        ));
        myOrdersInProgress.addAll(myOrderResponse.orders.where(
          (order) => order.status == 'IN_PROGRESS' && order.deletedAt == null
        ));

      } else {
        if (kDebugMode) {
          print('Erreur lors de la récupération des commandes : ${response?.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('orders : $e');
      }
    }
  }

  void initializeOrderTotals() async {
    await getDeliveryCost();
    totalOrder.value = (getTotalCostOrder() + getTotalPrice()).toDouble();
    totalDeliveryCost.value = getTotalWeight() * 
      (deliveryMode.value == DELIVERY_MODE_AIR ? 
        deliveryCostModel.value?.costAir ?? 0 : 
        deliveryCostModel.value?.costSea ?? 0);
  }
}


