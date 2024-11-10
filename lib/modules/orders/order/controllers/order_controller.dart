import 'package:afrika_baba/data/models/Delivery_cost_model.dart';
import 'package:afrika_baba/data/models/delivey_batch_model.dart';
import 'package:afrika_baba/data/models/my_order_response.dart';
import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/providers/order_api_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  
  OrderApiProvider orderApiProvider;
  
  RxList<Order> myOrdersPending = <Order>[].obs;
  RxList<Order> myOrdersDelivered = <Order>[].obs;
  RxList<Order> myOrdersRejected = <Order>[].obs;
  RxList<Order> myOrdersCanceled = <Order>[].obs;
  RxList<Order> myOrdersInProgress = <Order>[].obs;

  Rx<String> selectedFilter = ''.obs;

  // Utiliser une énumération pour les modes de livraison
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

  @override
  void onInit() {
    super.onInit();
    getMyOrders();
    getDeliveryCost().then((_) {
      updateTotalOrder(DELIVERY_MODE_SEA);
    });
    // getDeliveryBatch();
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
    return cartController.product_cart.fold(
        0.0,
        (sum, element) =>
            sum +
            ((element.product.productWeight * element.quantity.value) *
              double.parse(element.product.shop.fraisInterne)));
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
        (sum, element) =>
            sum + (element.quantity.value * element.product.productWeight));
  }

  // Future<void> getDeliveryBatch() async {
  //   final user = localStorageProvider.getUser();
  //   if (user == null) {
  //     if (kDebugMode) {
  //       print('User not found');
  //     }
  //     return;
  //   }
  //   try {
  //     final response = await orderApiProvider.getDeliveryBatch(
  //       country: user.country,
  //       deliveryMethod: deliveryMode.value == DELIVERY_MODE_AIR ? "AIR" : "SEA"
  //     );
  //     if (response != null && response.data['data'] is Map<String, dynamic>) {
  //       deliveryBatchesResponse.value =  DeliveryBatchesResponse.fromJson(response.data['data']);
  //     } else {
  //       print('Unexpected response format for delivery batch');
  //     }
  //   } catch (e) {
  //     print('Error fetching delivery batch: $e');
  //   }
  // }

  void updateTotalOrder(int mode) {
    if (deliveryCostModel.value == null){
      return;
    }
    deliveryMode.value = mode;
    totalDeliveryCost.value = getTotalWeight() * 
    (mode == DELIVERY_MODE_AIR ? deliveryCostModel.value?.costAir ?? 0 : deliveryCostModel.value?.costSea ?? 0);
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

      final response = await orderApiProvider.createOrder(
        deliveryMethod: deliveryMode.value.toString(),
        deliveryCost: totalDeliveryCost.value.toString(),
        totalPrice: totalOrder.value.toString(),
        orderItems: orderItems
      );
      if (response?.statusCode == 200 && response?.data != null) {
        Get.toNamed(AppRoutes.PAYMENT_CONFIRMATION_SCREEN);
      } else {
        print('Unexpected response format for order creation');
      }
    } catch (e) {
      print('Error creating order: $e');
    }
  }


  Future<void> getMyOrders({int page = 1}) async {
  try {

    final response = await orderApiProvider.getMyOrders(page: page);
  
    if (response?.statusCode == 200 && response?.data != null) {
    
      MyOrderResponse myOrderResponse = MyOrderResponse.fromJson(response?.data); 
 
      myOrdersPending.addAll(myOrderResponse.orders.where((order) => order.status == 'PENDING'));
      myOrdersDelivered.addAll(myOrderResponse.orders.where((order) => order.status == 'DELIVERED'));
      myOrdersRejected.addAll(myOrderResponse.orders.where((order) => order.status == 'REJECTED'));
      myOrdersCanceled.addAll(myOrderResponse.orders.where((order) => order.status == 'CANCELED'));
      myOrdersInProgress.addAll(myOrderResponse.orders.where((order) => order.status == 'IN_PROGRESS'));
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

  Future<String> generatePaymentLink(String paymentMethod) async {
    return '';
  }
}
