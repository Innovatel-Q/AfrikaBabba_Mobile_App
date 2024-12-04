import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/alert_dialogue.dart';
import '../controllers/cart_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConfirmationScreen extends GetView<OrderController> {

  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
  final AuthController authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();
  final RxString selectedPaymentMethod = ''.obs;

  ConfirmationScreen({super.key});

 
  @override
  Widget build(BuildContext context) {
   
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textScaleFactor = width / 375;
    final paddingScaleFactor = height / 812;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.0),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () => Get.back(),
            ),
            title: Text(
              "Récapitulatif commande",
              style: GoogleFonts.poppins(
                fontSize: 16 * textScaleFactor,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16 * paddingScaleFactor),
                          padding: EdgeInsets.all(16 * paddingScaleFactor),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Récapitulatif",
                                style: GoogleFonts.poppins(
                                  fontSize: 16 * textScaleFactor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16 * paddingScaleFactor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Produits",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: btnColor,
                                    ),
                                  ),
                                  Obx(() => Text(
                                    "${cartController.totalProduct} article${cartController.totalProduct > 1 ? 's' : ''}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 20 * paddingScaleFactor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Poids total",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: btnColor,
                                    ),
                                  ),
                                  Obx(() => Text(
                                    "${controller.getTotalWeight().toStringAsFixed(2)} kg",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 20 * paddingScaleFactor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Frais de livraison",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: btnColor,
                                    ),
                                  ),
                                  Obx(() => Text(
                                    "${controller.totalDeliveryCost.value.toStringAsFixed(0)} FCFA",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  )),
                                ],
                              ),
                              Divider(height: 32 * paddingScaleFactor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total à payer",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16 * textScaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: btnColor,
                                    ),
                                  ),
                                  Obx(() => Text(
                                    "${(controller.totalOrder.value + controller.totalDeliveryCost.value).toStringAsFixed(0)}FCFA",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16 * textScaleFactor,
                                      fontWeight: FontWeight.w500,
                                      color: btnColor,
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Section Méthodes de paiement
                        Container(
                          margin: EdgeInsets.all(16 * paddingScaleFactor),
                          padding: EdgeInsets.all(16 * paddingScaleFactor),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mode de paiement",
                                style: GoogleFonts.poppins(
                                  fontSize: 14 * textScaleFactor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16 * paddingScaleFactor),
                              _buildPaymentOption('paypal', 'PayPal', 'payment'),
                              SizedBox(height: 12 * paddingScaleFactor),
                              _buildPaymentOption('orange', 'Orange Money', 'phone_android'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildPaymentButton(context),
              ],
            ),
          ),
        ),
        // Loader overlay
        Obx(() => controller.isLoadingCreate.value
          ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            )
          : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String method, String title, String iconData) {
    return Obx(() => InkWell(
      onTap: () => selectedPaymentMethod.value = method,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPaymentMethod.value == method ? btnColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selectedPaymentMethod.value == method ? btnColor.withOpacity(0.1) : Colors.white,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedPaymentMethod.value == method ? btnColor.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: method == 'paypal' 
                  ? const Icon(Icons.payment, color: Colors.blue)
                  : const Icon(Icons.phone_android, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: selectedPaymentMethod.value == method ? btnColor : Colors.black,
              ),
            ),
            const Spacer(),
            if (selectedPaymentMethod.value == method)
              const Icon(Icons.check_circle, color: btnColor),
          ],
        ),
      ),
    ));
  }

  Widget _buildPaymentButton(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final paddingScaleFactor = height / 812;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16 * paddingScaleFactor,
        vertical: 8 * paddingScaleFactor,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
            text: "Payer maintenant",
            onPressed: _processPayment,
            color: btnColorFourth,
            elevation: 0,
          ),
    );
  }

  void _processPayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar('Opps!', 'Veuillez sélectionner un mode de paiement');
      return;
    }

    if (authController.userData.value?.address == null ||
        authController.userData.value!.address!.isEmpty) {
      Get.dialog(
        CustomAlertDialogue(
          title: 'Alerte',
          content:
          'Veuillez renseigner une adresse avant de continuer',
          canceledText: 'Non',
          confirmationText: 'Oui',
          canceledFunction: () {
            Get.back();
          },
          confirmationFunction: (){
            Get.back();
           Get.toNamed(AppRoutes.DELIVERY_ADRESS_SCREEN);
          },
        ),
      );
      return;
    }

    try {
      Get.dialog(
        CustomAlertDialogue(
          title: 'Alerte',
          content:
          'Êtes-vous toujours dans votre pays de résidence ? Si oui, confirmez. '
              'Sinon, veuillez vous rendre dans les paramètres pour changer votre pays de résidence.',
          canceledText: 'Non',
          confirmationText: 'Oui',
          canceledFunction: () {
            Get.toNamed(AppRoutes.PROFILE);
          },
          confirmationFunction: () async {
            Get.back(); // Ferme le dialogue de confirmation
            await controller.createOrder();
          },
        ),
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors du traitement du paiement');
    }
  }
}
