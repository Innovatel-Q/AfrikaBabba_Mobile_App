import 'package:afrika_baba/modules/auth/bindings/auth_binding.dart';
import 'package:afrika_baba/modules/auth/views/login_first.dart';
import 'package:afrika_baba/modules/auth/views/login_screen.dart';
import 'package:afrika_baba/modules/auth/views/signup_screen.dart';
import 'package:afrika_baba/modules/chats/views/chats_screen.dart';
import 'package:afrika_baba/modules/home/bindings/home_binding.dart';
import 'package:afrika_baba/modules/home/views/home_page.dart';
import 'package:afrika_baba/modules/home/views/start_screnn.dart';
import 'package:afrika_baba/modules/orders/cart/bindings/cart_binding.dart';
import 'package:afrika_baba/modules/orders/cart/views/cart_screen.dart';
import 'package:afrika_baba/modules/orders/cart/views/delyvery_mode_screen.dart';
import 'package:afrika_baba/modules/orders/cart/views/payment_confirmation_screen.dart';
import 'package:afrika_baba/modules/orders/order/bindings/order_binding.dart';
import 'package:afrika_baba/modules/user/bindings/user_binding.dart';
import 'package:afrika_baba/modules/user/views/information_personel.dart';
import 'package:afrika_baba/modules/user/views/profil_user_screen.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/no_connection_srenn.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const StartPage(),  
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.CHAT_SCREEN,
      page: () => ChatScreen(),
      bindings: [
        HomeBinding(),
        AuthBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () =>  HomePage(),
      bindings: [
        HomeBinding(),
        AuthBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.FIRSTLOGIN,
       page: () =>  LoginFirstScreen(),
       binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.LOGIN,
       page: () => LoginScreen(), 
       binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.SIGNUP, 
      page: () => const SignUpScreen(), 
      binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileScreen(),
      bindings: [ 
        UserBinding(),
        OrderBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.PAY_SCREEN,
      page: () => CartScreen(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRoutes.EDITE_PROFILE,
      page: () => InformationPersonel(),
      binding: UserBinding(),
    ),
    GetPage(
      name: AppRoutes.DELIVERY_METHOD,
      binding: OrderBinding(),
      page: ()=> DeliveryModeScreen()
     ),
     GetPage(
      name: AppRoutes.NO_CONNECTION,
      page: () => const NoConnectionScreen(),
     ),
     GetPage(
      name: AppRoutes.PAYMENT_CONFIRMATION_SCREEN,
      page: () => const PaymentConfirmationScreen(),
     ),
     GetPage(
      name: AppRoutes.CART,
      page: () => CartScreen(),
      bindings: [
        CartBinding(),
        OrderBinding(),
      ],
     )
  ];
}
