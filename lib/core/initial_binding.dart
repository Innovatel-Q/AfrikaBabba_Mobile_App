import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/providers/api_provider.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/services/connectivity_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(LocalStorageProvider(), permanent: true);
    Get.put(ConnectivityController(), permanent: true);
    Get.put(ApiProvider(), permanent: true);
    Get.put(CartController(), permanent: true);
  }
}