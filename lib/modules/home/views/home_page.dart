import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/services/connectivity_service.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/bottom_navigation_bar.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    final connectivityController = Get.find<ConnectivityController>();
    final cartController = Get.find<CartController>();
    
  return Scaffold(
   backgroundColor: backgroundAppColor,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Text(
            'Découverte',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.025,
              color: btnColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: screenWidth * 0.025, top: screenHeight * 0.02),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Image.asset(
                    "assets/panier2.png",
                    height: screenHeight * 0.03,
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.CART);
                  },
                ),
                Positioned(
                  right: -1,
                  top: -3,
                  child: Obx(() => cartController.totalProduct.value == 0
                      ? Container()
                      : CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: screenHeight * 0.011,
                          child: Text(
                            cartController.totalProduct.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.012,
                            ),
                          ),
                        )),
                ),
              ],
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Obx(() {
              if (controller.products.isEmpty &&
                  !controller.isLoading.value) {
                return _buildEmptyState(screenHeight, btnColor);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: textColor),
                  SizedBox(height: screenHeight * 0.02),
                  _buildCategoriesSection(screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.05),
                  _buildPopularProductsHeader(screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return _buildSkeletonLoader(screenHeight, screenWidth);
                      }
                      if (controller.products.isEmpty) {
                        return _buildEmptyState(screenHeight, btnColor);
                      }
                      return _buildProductGrid(screenWidth, screenHeight);
                    }),
                  ),
                ],
              );
            }),
          ),
          CustomBottomNavigationBar(selectedIndex: 0),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double screenHeight, Color btnColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: screenHeight * 0.15,
            color: btnColor.withOpacity(0.7),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Aucun produit disponible',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.02,
              color: btnColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Revenez plus tard pour découvrir nos produits',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.016,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(double screenHeight, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.025),
          child: Text(
            'Catégories',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
              color: btnColor,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.05),
        Obx(() {
          if (controller.categories.isEmpty) {
            return Center(
              child: Text(
                'Aucune catégorie disponible',
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.016,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.categories.map((category) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.performSearchByCategory(
                          null, category.id);
                    },
                    icon: _getCategoryIcon(category.name),
                    label: Text(
                      category.name.toLowerCase(),
                      style: GoogleFonts.poppins(
                        color: btnColor,
                        fontSize: screenHeight * 0.016,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: btnColor),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPopularProductsHeader(double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.025),
          child: Text(
            'Produit populaire',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: btnColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: GestureDetector(
            onTap: () {
             Get.toNamed(AppRoutes.ALL_PRODUCT);
            },
            child: Text(
              'Voir tout',
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.018,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(double screenWidth, double screenHeight) {
    return GridView.builder(
      itemCount: controller.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.5,
        crossAxisSpacing: screenWidth * 0.025,
      ),
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: ProductCard(
            product: product,
            imageHeight: screenHeight * 0.12,
            imageWidth: screenWidth * 0.15,
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader(double screenHeight, double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.5,
          crossAxisSpacing: screenWidth * 0.025,
        ),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * 0.12,
                width: screenWidth * 0.28,
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                height: screenHeight * 0.02,
                width: screenWidth * 0.2,
                color: Colors.white,
              ),
              SizedBox(height: screenHeight * 0.005),
              Container(
                height: screenHeight * 0.015,
                width: screenWidth * 0.15,
                color: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }

  Icon _getCategoryIcon(String categoryName) {
    switch (categoryName.toUpperCase()) {
      case 'NOURRITURE':
        return const Icon(Icons.restaurant, color: btnColor);
      case 'BEAUTE':
        return const Icon(Icons.face, color: btnColor);
      case 'JEUX':
        return const Icon(Icons.sports_esports, color: btnColor);
      case 'VETEMENT':
        return const Icon(Icons.shopping_bag, color: btnColor);
      case 'ELECTRONIQUE':
        return const Icon(Icons.devices, color: btnColor);
      case 'CUISINE':
        return const Icon(Icons.kitchen, color: btnColor);
      default:
        return const Icon(Icons.category, color: btnColor);
    }
  }
}
