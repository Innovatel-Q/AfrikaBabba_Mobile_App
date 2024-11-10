import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/providers/auth_api_provider.dart';
import 'package:afrika_baba/providers/product_api_provider.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiProvider>(() => AuthApiProvider());
    Get.put<UserController>(UserController(apiProvider: Get.find<AuthApiProvider>()));
    Get.lazyPut<ProductApiProvider>(() => ProductApiProvider());
    Get.put(HomeController(
      productApiProvider: Get.find<ProductApiProvider>(),
    ));
  }
}