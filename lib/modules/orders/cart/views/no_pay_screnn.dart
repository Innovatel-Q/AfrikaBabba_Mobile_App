import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/product_custom/build_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoPayScreen extends StatelessWidget {
  

  NoPayScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
     final cartController = Get.find<CartController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Obx(() {
      if (cartController.product_cart.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: width * 0.2,
                color: Colors.grey,
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Votre panier est vide',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: height * 0.01),
              Padding(padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Text(
                'Ajoutez des produits pour commencer vos achats',
                style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),),
              SizedBox(height: height * 0.05),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: textgrennColor,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Commencer vos achats',
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return ListView.builder(
          itemCount: cartController.product_cart.length + 1,
          itemBuilder: (context, index) {
            if (index == cartController.product_cart.length) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => Text(
                          '${cartController.totalPrice} FCFA',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/delivery-method');  
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textgrennColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Commander maintenant',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final product = cartController.product_cart[index];
              return Dismissible(
                key: Key(product.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  cartController.removeProduct(product);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: buildCartItem(product: product, context: context),
                ),
              );
            }
          },
        );
      }
    });
  }
}