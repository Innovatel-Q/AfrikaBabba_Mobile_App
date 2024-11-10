import 'package:afrika_baba/modules/orders/cart/views/confimation_screen.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/cart_controller.dart';

class DeliveryModeScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  DeliveryModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: btnColor, size: width * 0.06),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Mode de livraison',
          style: GoogleFonts.poppins(
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
            color: btnColor
          ),
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
            child: CustomButton(
              size: 15,
              text: 'Confirmez mode livraison',
              onPressed: () {
                Get.to(() =>  ConfirmationScreen());
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nombre de produits : ${orderController.cartController.totalProduct}',
          style: GoogleFonts.poppins(fontSize: width * 0.04, color: Colors.black87),
        ),
        SizedBox(height: height * 0.01),
        Text(
          'Poids total : ${orderController.getTotalWeight().toStringAsFixed(2)} kg',
          style: GoogleFonts.poppins(fontSize: width * 0.04, color: Colors.black87),
        ),
        SizedBox(height: height * 0.01),
        Obx(() {
          return Text(
            'Frais de livraison : ${orderController.totalDeliveryCost.toStringAsFixed(0)} FCFA',
            style: GoogleFonts.poppins(fontSize: width * 0.04, color: Colors.black87),
          );
        }),
        SizedBox(height: height * 0.05),
        Obx(() {
          return Text(
            'Total : ${orderController.totalOrder.value.toStringAsFixed(0)} FCFA',
            style: GoogleFonts.poppins(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeliveryOptions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDeliveryOption(context, 'Bateau', Icons.directions_boat, OrderController.DELIVERY_MODE_SEA),
        _buildDeliveryOption(context, 'Avion', Icons.airplanemode_active, OrderController.DELIVERY_MODE_AIR),
      ],
    );
  }

  Widget _buildDeliveryOption(BuildContext context, String title, IconData icon, int value) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      final isSelected = orderController.deliveryMode.value == value;
      return GestureDetector(
        onTap: () {
          orderController.updateTotalOrder(value);
        },
        child: Column(
          children: [
            Container(
              width: width * 0.2,
              height: width * 0.2,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.circular(width * 0.02),
              ),
              child: Icon(icon, size: width * 0.1, color: isSelected ? Colors.white : Colors.black),
            ),
          ],
        ),
      );
    });
  }
}
