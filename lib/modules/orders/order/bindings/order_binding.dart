import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/providers/order_api_provider.dart';
import 'package:get/get.dart';


class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderApiProvider>(() => OrderApiProvider());
    Get.put(OrderController(orderApiProvider: Get.find<OrderApiProvider>()));
  }
}