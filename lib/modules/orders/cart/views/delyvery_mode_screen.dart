import 'package:afrika_baba/modules/orders/cart/views/confimation_screen.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';

class DeliveryModeScreen extends GetView<OrderController> {
  
  final CartController cartController = Get.find<CartController>();
  DeliveryModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: btnColor, size: width * 0.05),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mode de livraison',
          style: GoogleFonts.poppins(
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
              color: btnColor),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: height * 0.05),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(width * 0.05),
              children: [
                _buildOrderSummary(context),
                SizedBox(height: height * 0.03),
                Divider(
                  color: Colors.grey,
                  height: height * 0.02,
                  thickness: 1,
                ),
                SizedBox(height: height * 0.03),
                Text(
                  'Mode de livraison',
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: height * 0.07),
                _buildDeliveryOptions(context),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            child: CustomButton(
              size: 15,
              text: 'Confirmez mode livraison',
              onPressed: () {
                Get.to(() => ConfirmationScreen());
              },
            ),
          ),
          SizedBox(height: height * 0.05),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nombre de produits : ${controller.cartController.totalProduct}',
            style: GoogleFonts.poppins(
                fontSize: width * 0.04, color: Colors.black87),
          ),
          SizedBox(height: height * 0.01),
          Text(
            'Poids total : ${controller.getTotalWeight().toStringAsFixed(2)} kg',
            style: GoogleFonts.poppins(
                fontSize: width * 0.04, color: Colors.black87),
          ),
          SizedBox(height: height * 0.01),
          Obx(() {
            return Text(
              'Frais de livraison : ${controller.totalDeliveryCost.toStringAsFixed(0)} FCFA',
              style: GoogleFonts.poppins(
                  fontSize: width * 0.04, color: Colors.black87),
            );
          }),
          SizedBox(height: height * 0.05),
          Obx(() {
            return Text(
              'Total : ${(controller.totalOrder.value + controller.totalDeliveryCost.value).toStringAsFixed(0)} FCFA',
              style: GoogleFonts.poppins(
                fontSize: width * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDeliveryOption(
          context,
          'Bateau',
          Icons.directions_boat_filled,
          OrderController.DELIVERY_MODE_SEA,
          'Maritime\n3-4 semaines',
        ),
        _buildDeliveryOption(
          context,
          'Avion',
          Icons.flight,
          OrderController.DELIVERY_MODE_AIR,
          'Aérien\n3-5 jours',
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(BuildContext context, String title, IconData icon,
      int value, String subtitle) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      final isSelected = controller.deliveryMode.value == value;
      return GestureDetector(
        onTap: () => controller.updateTotalOrder(value),
        child: Container(
          width: width * 0.4,
          padding: EdgeInsets.all(width * 0.03),
          decoration: BoxDecoration(
            color: isSelected ? btnColor.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? btnColor : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  color: isSelected ? btnColor : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: width * 0.08,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: width * 0.02),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? btnColor : Colors.black87,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.03,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
