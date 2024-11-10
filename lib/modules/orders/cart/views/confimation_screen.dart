import 'package:afrika_baba/modules/auth/controllers/auth_controller.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/modules/user/views/delivery_address.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/cart_controller.dart';

class ConfirmationScreen extends StatelessWidget {
  final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();
  final RxString selectedPaymentMethod = ''.obs;

  ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final textScaleFactor = width / 375;
    final paddingScaleFactor = height / 812;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(); 
          },
        ),
        title: Text(
          "Passant à la caisse",
          style: GoogleFonts.poppins(
            fontSize: 18 * textScaleFactor,
            fontWeight: FontWeight.bold,
            color: btnColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20 * paddingScaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adresse de livraison
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adresse de livraison",
                  style: GoogleFonts.poppins(
                    fontSize: 14 * textScaleFactor,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Action modifier
                  },
                  child:GestureDetector(
                    onTap: () {
                      Get.to(() => const DeliveryAddressScreen());
                    },
                    child: const Text(
                      "modifier",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * paddingScaleFactor),
           Obx(() => Text(
              authController.userData.value?.address ?? 'Adresse non renseignée',
              style: GoogleFonts.poppins(
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.w500,
                color: btnColor,
              ),
            )),
            const SizedBox(height: 10),
            Text(
              authController.userData.value?.phoneNumber ?? 'Numéro de téléphone non renseigné',
              style: GoogleFonts.poppins(
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.w500,
                color: btnColor,
              ),
            ),
            Divider(height: 32 * paddingScaleFactor, thickness: 1),
            // Votre commande
            Text(
              "Votre commande",
              style: GoogleFonts.poppins(
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 20 * paddingScaleFactor),
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
                  "${orderController.getTotalWeight().toStringAsFixed(2)} kg",
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
                  "${orderController.totalDeliveryCost.value.toStringAsFixed(0)} FCFA",
                  style: GoogleFonts.poppins(
                    fontSize: 14 * textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                )),
              ],
            ),
            SizedBox(height: 40 * paddingScaleFactor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.poppins(
                    fontSize: 16 * textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: btnColor,
                  ),
                ),
                Obx(() => Text(
                  "${orderController.totalOrder.value.toStringAsFixed(0)}F",
                  style: GoogleFonts.poppins(
                    fontSize: 16 * textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: btnColor,
                  ),
                )),
              ],
            ),
            
            SizedBox(height: 20 * paddingScaleFactor),
            Text(
              "Mode de paiement",
              style: GoogleFonts.poppins(
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 10 * paddingScaleFactor),
            Row(
              children: [
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: () => selectedPaymentMethod.value = 'paypal',
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPaymentMethod.value == 'paypal' ? btnColor : Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('PayPal', style: TextStyle(color: selectedPaymentMethod.value == 'paypal' ? Colors.white : Colors.black)),
                  )),
                ),
                SizedBox(width: 10 * paddingScaleFactor),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: () => selectedPaymentMethod.value = 'orange',
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPaymentMethod.value == 'orange' ? btnColor : Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Orange', style: TextStyle(color: selectedPaymentMethod.value == 'orange' ? Colors.white : Colors.black)),
                  )),
                ),
              ],
            ),
            
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20 * paddingScaleFactor),
              child: CustomButton(
                text: "Confirmez la commande",
                onPressed: () => _processPayment(),
                color: btnColorFourth,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un mode de paiement');
      return;
    }

    try {
      String paymentUrl = await orderController.generatePaymentLink(selectedPaymentMethod.value);
      if (await canLaunch(paymentUrl)) {
        await launch(paymentUrl);
      } else {
        throw 'Impossible d\'ouvrir le lien de paiement';
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue lors du traitement du paiement');
    }
  }
}
