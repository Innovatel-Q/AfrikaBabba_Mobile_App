
import 'package:afrika_baba/providers/api_provider.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class OrderApiProvider{

  final ApiProvider apiProvider = Get.find<ApiProvider>();
  

  Future<dio.Response?> getDeliveryCost() async {
    try {
      final response = await apiProvider.dio.get('/delivery_costs');
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du coût de livraison : $e');
    }
  }

 

  Future<dio.Response?> createOrder({
    required String deliveryMethod,
    required String deliveryCost,
    required String totalPrice,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final response = await apiProvider.dio.post('/orders', data: {
        'delivery_method': deliveryMethod,
        'delivery_cost': deliveryCost,
        'total_price': totalPrice,
        'order_items': orderItems,
      });
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la création de la commande : $e');
    }
  }

  Future<dio.Response?> getMyOrders({int page = 1}) async {
    try {
      final userId =  LocalStorageProvider().getUser()!.id;
      final response = await apiProvider.dio.get('/orders', queryParameters: {
        'user_id': userId,
        'page': page,
      });
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des commandes : $e');
    }
  }


  Future<dio.Response?> getDeliveryBatch({required String country, required String deliveryMethod}) async {
    try {
      final response = await apiProvider.dio.post(
        '/delivery-batches/last',
        data: {
          'country': country,
          'delivery_method': deliveryMethod,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du dernier lot de livraison : $e');
    }
  }

  Future<dio.Response?> createOrderItem({
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final response = await apiProvider.dio.post('/order_items', data: {
        'order_items': orderItems,
      });
      return response;
    } catch (e) {
      throw Exception('Erreur lors de la création des éléments de commande : $e');
    }
  }

  
}