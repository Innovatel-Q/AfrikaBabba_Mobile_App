import 'dart:io';
import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/auth/views/reset_password_scree.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/modules/user/controllers/user_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/bottom_navigation_bar.dart';
import 'package:afrika_baba/shared/widgets/users_widget/build_profil_option.dart';
import 'package:afrika_baba/shared/widgets/users_widget/build_profil_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends GetView<UserController> {
  ProfileScreen({super.key});

  final authController = Get.find<AuthController>();
  final localStorage = Get.find<LocalStorageProvider>();
  final orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.green[600],
                  padding: EdgeInsets.symmetric(vertical: height * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: GestureDetector(
                          onTap: controller.selectImage,
                          child: Obx(() {
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: width * 0.15,
                              child: ClipOval(
                                child: controller.imagePath.value.isNotEmpty
                                    ? Image.file(
                                        File(controller.imagePath.value),
                                        width: width * 0.3,
                                        height: width * 0.3,
                                        fit: BoxFit.cover,
                                      )
                                    : (localStorage.getUser()?.avatar_url !=
                                            null)
                                        ? CachedNetworkImage(
                                            imageUrl: localStorage
                                                    .getUser()!
                                                    .avatar_url!
                                                    .isEmpty
                                                ? 'https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg'
                                                : localStorage
                                                    .getUser()!
                                                    .avatar_url!,
                                            width: width * 0.3,
                                            height: width * 0.3,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child: SpinKitWave(
                                              color: btnColor,
                                              size: 25,
                                            )),
                                          )
                                        : Image.asset(
                                            width: width * 0.3,
                                            height: width * 0.3,
                                            "assets/default.png",
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () => Text(
                          authController.userData.value?.email ?? '',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: width * 0.040,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BuildProfilState(
                                number: orderController.myOrders.length.toString(),
                                label: 'commandes',
                                width: width),
                            buildDivider(),
                            BuildProfilState(
                                number: orderController.myOrdersViews.length.toString(),
                                label: 'Visite de listes',
                                width: width),
                            buildDivider(),
                            BuildProfilState(
                                number: orderController.myOrdersCanceled.length.toString(),
                                label: 'Articles annulés',
                                width: width),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                BuildProfilOption(
                    title: 'Informations personnelle',
                    width: width,
                    onTap: () {
                      Get.toNamed(AppRoutes.EDITE_PROFILE);
                    }),
                BuildProfilOption(
                    title: 'Mes commandes',
                    width: width,
                    onTap: () {
                      Get.toNamed(AppRoutes.CART);
                    }),
                BuildProfilOption(
                    title: 'Adresse de livraison',
                    width: width,
                    onTap: () {
                      Get.toNamed(AppRoutes.DELIVERY_ADRESS_SCREEN);
                    }),
                BuildProfilOption(
                    title: 'Changer de mot de passe',
                    width: width,
                    onTap: () {
                      Get.to(ResetPasswordScreen());
                    }),
                Divider(color: Colors.grey[200], thickness: 8),
                // BuildProfilOption(title: 'Nous contacter', width: width),
                BuildProfilOption(
                  title: 'Déconnexion',
                  width: width,
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(
                          'Déconnexion',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                          'Êtes-vous sûr de vouloir vous déconnecter ?',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Annuler',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => authController.logout(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Déconnecter',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: height * 0.07),
                Text(
                  'Afrikababa\nversion: 1.0',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: width * 0.035,
                  ),
                ),
                SizedBox(height: height * 0.19),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(selectedIndex: 4),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 20,
      width: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
