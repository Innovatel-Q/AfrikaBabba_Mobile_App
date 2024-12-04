
    import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/providers/auth_api_provider.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthApiProvider>(() => AuthApiProvider());
    Get.lazyPut<AuthController>(() => AuthController(
      authApiProvider: Get.find<AuthApiProvider>(),
    ));
  }
}
