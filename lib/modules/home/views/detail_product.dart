import 'package:afrika_baba/core/utils/utils.dart';
import 'package:afrika_baba/modules/chats/controllers/ChatController.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/data/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'comment_bottom_sheet.dart';

class DetailProduct extends GetView<HomeController> {
  final Product product;
  DetailProduct({super.key, required this.product});

  final carouselController = CarouselSliderController();
  final cartController = Get.find<CartController>();
  final chatController = Get.find<ChatController>();
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 375;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.toNamed(AppRoutes.HOME),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                Stack(
                  children: [
                    product.productMedia.isEmpty
                        ? Container(
                            height: size.height * 0.45,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 60 * textScale,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucune image disponible',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16 * textScale,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CarouselSlider(
                            carouselController: carouselController,
                            options: CarouselOptions(
                              height: size.height * 0.45,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                currentIndex.value = index;
                              },
                            ),
                            items: product.productMedia
                                .map((media) => CachedNetworkImage(
                                      imageUrl: media.mediaUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      placeholder: (context, url) => const Center(
                                        child: SpinKitWave(color: btnColor),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              size: 60 * textScale,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Erreur de chargement',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16 * textScale,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                    // Indicateurs de pagination
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: product.productMedia.isEmpty
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.productMedia.length,
                                (index) => Obx(() => Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex.value == index
                                        ? btnColor
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                )),
                              ),
                            ),
                    ),
                  ],
                ),
                // Contenu principal
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête du produit
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03,
                                    vertical: size.height * 0.006,
                                  ),
                                  decoration: BoxDecoration(
                                    color: btnColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    product.category.name,
                                    style: GoogleFonts.poppins(
                                      color: btnColor,
                                      fontSize: 12 * textScale,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20 * textScale,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${Utils.formatPrice(product.price)}F',
                              style: GoogleFonts.poppins(
                                fontSize: 16 * textScale,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      // Section des avis
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => CommentBottomSheet(
                              product: product,
                              homeController: controller,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02,
                                  vertical: size.height * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 18 * textScale),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      _calculateAverageRating(product.reviews)
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14 * textScale,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Text(
                                '${product.reviews.length} avis',
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16 * textScale,
                                  color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      // Livraison
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_shipping_outlined,
                                color: Colors.green[700],
                                size: 20 * textScale),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              'Livraison gratuite',
                              style: GoogleFonts.poppins(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 14 * textScale,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      // Informations sur la boutique
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.9,
                                minChildSize: 0.5,
                                maxChildSize: 0.9,
                                builder: (_, controller) => Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  padding: EdgeInsets.all(size.width * 0.05),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: product.shop.logo ?? "https://img.freepik.com/free-vector/shop-with-sign-open-design_23-2148544029.jpg",
                                              width: 60 * textScale,
                                              height: 60 * textScale,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons.store,
                                                  color: Colors.grey[400],
                                                  size: 24 * textScale,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.shop.companyName,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18 * textScale,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  product.shop.city ?? 'Aucune ville renseignée',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14 * textScale,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      Container(
                                        padding: EdgeInsets.all(size.width * 0.03),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 20 * textScale,
                                                  color: Colors.blue[700],
                                                ),
                                                SizedBox(width: size.width * 0.02),
                                                Text(
                                                  'Responsable: ',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14 * textScale,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  product.shop.salesManagerName ?? 'Non renseigné',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14 * textScale,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: size.height * 0.01),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 20 * textScale,
                                                  color: Colors.red[700],
                                                ),
                                                SizedBox(width: size.width * 0.02),
                                                Expanded(
                                                  child: Text(
                                                    product.shop.address ?? 'Adresse non renseignée',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14 * textScale,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.02),
                                      Text(
                                        'À propos de la boutique',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16 * textScale,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          controller: controller,
                                          child: Text(
                                            product.shop.description ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14 * textScale,
                                              color: Colors.black87,
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.shop.logo ?? "https://img.freepik.com/free-vector/shop-with-sign-open-design_23-2148544029.jpg",
                                  width: 40 * textScale,
                                  height: 40 * textScale,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.store,
                                      color: Colors.grey[400],
                                      size: 24 * textScale,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.shop.companyName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14 * textScale,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Voir la boutique',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12 * textScale,
                                        color: btnColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 16 * textScale, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      // Description
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: 18 * textScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        product.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14 * textScale,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: size.height * 0.12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Boutons d'action
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => chatController.createConversation(
                          product.shop.userId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: btnColor,
                        elevation: 0,
                        side: const BorderSide(color: btnColor),
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.chat_bubble_outline,
                          size: 20 * textScale),
                      label: Text(
                        'Chat',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * textScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () => cartController.addProduct(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.shopping_cart_outlined,
                          size: 20 * textScale),
                      label: Text(
                        'Ajouter au panier',
                        style: GoogleFonts.poppins(
                          fontSize: 14 * textScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    double sum = reviews.fold(0, (prev, review) => prev + review.rating);
    return double.parse((sum / reviews.length).toStringAsFixed(1));
  }
}

