import 'package:afrika_baba/core/initial_binding.dart';
import 'package:afrika_baba/routes/app_pages.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/services/notification_service.dart';
import 'package:afrika_baba/services/pusher_service.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Get.putAsync<PusherService>(() => PusherService().init());
  await GetStorage.init();  
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Africa Baba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: btnColor),
        useMaterial3: false,
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.INITIAL,
      getPages: AppPages.pages,
    );
  }
}
