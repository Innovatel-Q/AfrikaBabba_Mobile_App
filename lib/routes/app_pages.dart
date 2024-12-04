import 'package:afrika_baba/modules/auth/bindings/auth_binding.dart';
import 'package:afrika_baba/modules/auth/views/login_first.dart';
import 'package:afrika_baba/modules/auth/views/login_screen.dart';
import 'package:afrika_baba/modules/auth/views/signup_screen.dart';
import 'package:afrika_baba/modules/chats/bindings/chat_binding.dart';
import 'package:afrika_baba/modules/chats/views/chat_detail_screen.dart';
import 'package:afrika_baba/modules/chats/views/chats_screen.dart';
import 'package:afrika_baba/modules/home/bindings/home_binding.dart';
import 'package:afrika_baba/modules/home/views/comment_product_screen.dart';
import 'package:afrika_baba/modules/home/views/detail_product.dart';
import 'package:afrika_baba/modules/home/views/home_page.dart';
import 'package:afrika_baba/modules/home/views/search_product.dart';
import 'package:afrika_baba/modules/home/views/start_screnn.dart';
import 'package:afrika_baba/modules/home/views/all_product_screen.dart';
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

import '../modules/user/views/delivery_address.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const StartPage(),  
      bindings: [
        AuthBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.CHAT_SCREEN,
      page: () => const ChatScreen(),
      bindings: [
        ChatBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () =>  const HomePage(),
      bindings: [
        HomeBinding(),
        AuthBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.FIRSTLOGIN,
       page: () =>  LoginFirstScreen(),
       bindings:[
         AuthBinding()
       ]
    ),
    GetPage(
      name: AppRoutes.LOGIN,
       page: () => LoginScreen(), 
       bindings: [
         AuthBinding()
       ]
    ),
    GetPage(
      name: AppRoutes.SIGNUP, 
      page: () => const SignUpScreen(), 
      bindings: [
        AuthBinding()
      ]
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
      bindings:[
        CartBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.EDITE_PROFILE,
      page: () => InformationPersonel(),
      bindings:[
        UserBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.DELIVERY_METHOD,
      bindings: [OrderBinding()],
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
     ),
     GetPage(
      name: AppRoutes.CHAT_DETAIL_SCREEN,
      page: () => ChatDetailScreen(conversationId: Get.arguments),
      bindings: [
        ChatBinding()
      ],
     ),
     GetPage(
      name: AppRoutes.PRODUCT_DETAIL,
      page: () => DetailProduct(product: Get.arguments),
      bindings: [
        HomeBinding(),
        ChatBinding(),
      ],
     ),
     GetPage(
      name: AppRoutes.SEARCH ,
      page: () => const SearchProduct(),
      bindings: [
        HomeBinding(),
        AuthBinding()
      ]

    ),
    GetPage(
      name: AppRoutes.ALL_PRODUCT,
      page: () => const AllProductScreen(),
      bindings: [
        HomeBinding(),
        AuthBinding()
      ]
    ),
    GetPage(
        name: AppRoutes.DELIVERY_ADRESS_SCREEN,
        page: () =>  DeliveryAddressScreen(),
        bindings: [
         HomeBinding(),
         AuthBinding()
        ]
    ),
    GetPage(
      name: AppRoutes.COMMENT_PRODUCT_SCREEN,
      page: () => AddCommentScreen(product: Get.arguments),
      bindings: [
        HomeBinding(),
        AuthBinding()
      ],
    ),
  ];
}
