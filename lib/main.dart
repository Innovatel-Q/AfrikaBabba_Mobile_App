import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/routes/app_pages.dart';
import 'package:afrika_baba/routes/app_routes.dart';
// import 'package:afrika_baba/services/connectivity_service.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
  // Get.put(ConnectivityController());
  Get.put(CartController(), permanent: true);
  Get.put(LocalStorageProvider(), permanent: true);
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Afrika Baba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: btnColor),
        useMaterial3: false,
      ),
      initialRoute: AppRoutes.INITIAL,
      getPages: AppPages.pages,
    );
  }
}
