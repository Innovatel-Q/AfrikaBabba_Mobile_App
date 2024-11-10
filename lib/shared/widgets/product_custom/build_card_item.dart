import 'package:afrika_baba/data/models/cart_model.dart';
import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/product_custom/build_quantity_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class buildCartItem extends StatelessWidget {

 final CartModel product;
 final BuildContext context;
 final Function()? onPressed;

 final List<String> productImages = [
      "https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Office product
      "https://images.unsplash.com/photo-1523381210434-271e8be1f52b?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Clothing
      "https://images.unsplash.com/photo-1498049794561-7780e7231661?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Electronics
      "https://images.unsplash.com/photo-1524758631624-e2822e304c36?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Office desk
      "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // T-shirts
      "https://images.unsplash.com/photo-1526738549149-8e07eca6c147?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Smartwatch
      "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Shoes
      "https://images.unsplash.com/photo-1542393545-10f5cde2c810?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Laptop
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Headphones
      "https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Desk accessories
      "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Clothing rack
      "https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Computer setup
      "https://images.unsplash.com/photo-1560769629-975ec94e6a86?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Colorful t-shirts
      "https://images.unsplash.com/photo-1546868871-7041f2a55e12?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Office supplies
      "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80", // Mobile phones
    ];

  buildCartItem({required this.product, required this.context, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final width = MediaQuery.of(this.context).size.width;
    final height = MediaQuery.of(this.context).size.height;
     return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.1,
                width: width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: product.product.mainImageUrl ?? 
                    productImages[DateTime.now().microsecond % productImages.length],
                    fit: BoxFit.cover,
                placeholder: (context, url) => const SpinKitFadingCircle(
                  color: btnColor,
                  size: 50.0,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.product.category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: btnColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.product.price.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: btnColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          )),
          Row(
            children: [
              BuildQuantityButton(icon: Icons.add, context: context, onPressed: () {
                cartController.incrementProduct(product.product);
              }),
              SizedBox(width: width * 0.03),
              Obx(() => Text(
                product.quantity.value.toString(),
                style: GoogleFonts.poppins(
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              )),
              SizedBox(width: width * 0.03),
              BuildQuantityButton(icon: Icons.remove, context: context, onPressed: () {
                cartController.decrementProduct(product.product);
              }),
            ],
          ),
        ],
      ),
    );
  }
  

}



