import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/bottom_navigation_bar.dart';
import 'package:shimmer/shimmer.dart';

class SearchProduct extends StatelessWidget {
  const SearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorageProvider = Get.find<LocalStorageProvider>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final homeController = Get.find<HomeController>();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.0),
        title: Text(
          'Recherche',
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.022,
            color: btnColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.012,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            color: Colors.grey[600], size: screenHeight * 0.028),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: TextField(
                            controller: homeController.value,
                            onChanged: (value) => homeController.onSearchChanged(value.toLowerCase()),
                            decoration: InputDecoration(
                              hintText: "Que recherchez-vous ?",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: screenHeight * 0.016,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Obx(() {
                    return homeController.searchQuery.value.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (homeController.searchHistory.isNotEmpty)
                                Text(
                                  "Historique de recherche",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenHeight * 0.018,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (homeController.searchHistory.isNotEmpty)
                                TextButton(
                                  onPressed: () => homeController.clearSearchHistory(),
                                  child: Text(
                                    "Effacer",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.016,
                                      color: btnColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                            ],
                          )
                        : const SizedBox.shrink();
                  }),
                  SizedBox(height: screenHeight * 0.015),
                  Expanded(
                    child: Obx(() {
                      if (homeController.searchQuery.value.isEmpty) {
                        return ListView(
                          children: [
                            if (homeController.searchHistory.isNotEmpty) ...[
                              ...homeController.searchHistory
                                  .map((historyItem) => _buildSearchHistoryItem(
                                      historyItem,
                                      screenHeight,
                                      screenWidth,
                                      homeController,
                                      localStorageProvider))
                                  .toList(),
                              SizedBox(height: screenHeight * 0.025),
                            ],
                            Text(
                              "Plus recherché",
                              style: GoogleFonts.poppins(
                                fontSize: screenHeight * 0.02,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            Wrap(
                              spacing: screenWidth * 0.03,
                              runSpacing: screenHeight * 0.015,
                              children: [
                                _buildModernTag("🔌 Mixeur", Colors.blue[100]!),
                                _buildModernTag("🎮 PC Gamer", Colors.purple[100]!),
                                _buildModernTag("💄 Cosmétique", Colors.pink[100]!),
                                _buildModernTag("👗 Mode", Colors.orange[100]!),
                                _buildModernTag("📱 Tech", Colors.green[100]!),
                                _buildModernTag("🏠 Maison", Colors.teal[100]!),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            if (homeController.products.isNotEmpty || homeController.isLoading.value) ...[
                              Divider(height: screenHeight * 0.04, thickness: 1, color: textgray),
                              SizedBox(height: screenHeight * 0.025),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pour Vous",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.toNamed(AppRoutes.ALL_PRODUCT),
                                    child: Text(
                                      'Voir tout',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.018,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: homeController.isLoading.value ? 9 : 
                                          (homeController.products.length > 10 ? 10 : homeController.products.length),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.5,
                                  crossAxisSpacing: screenWidth * 0.025,
                                  mainAxisSpacing: screenHeight * 0.02,
                                ),
                                itemBuilder: (context, index) {
                                  if (homeController.isLoading.value) {
                                    return _buildSkeletonLoader(screenHeight, screenWidth);
                                  }
                                  final product = homeController.products[index];
                                  return GestureDetector(
                                    onTap: () => Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product),
                                    child: ProductCard(
                                      product: product,
                                      imageHeight: screenHeight * 0.12,
                                      imageWidth: screenWidth * 0.15,
                                    ),
                                  );
                                },
                              ),
                            ] else ...[
                              _buildNoProductsMessage(screenHeight, screenWidth),
                            ],
                          ],
                        );
                      } else {
                        if (homeController.searchSuggestions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: screenHeight * 0.08,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Text(
                                  'Aucune suggestion trouvée',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenHeight * 0.022,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Essayez une autre recherche',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenHeight * 0.018,
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeController.searchSuggestions.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: screenHeight * 0.03),
                            itemBuilder: (context, index) {
                              final suggestion =
                                  homeController.searchSuggestions[index];
                              return _buildSearchHistoryItem(
                                  suggestion,
                                  screenHeight,
                                  screenWidth,
                                  homeController,
                                  localStorageProvider);
                            },
                          );
                        }
                      }
                    }),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (homeController.searchQuery.value.isEmpty &&
                  MediaQuery.of(context).viewInsets.bottom == 0) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: CustomBottomNavigationBar(selectedIndex: 3),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistoryItem(
      String text,
      double screenHeight,
      double screenWidth,
      HomeController homeController,
      LocalStorageProvider localStorageProvider) {
    return GestureDetector(
      onTap: () {
        homeController.value.text = text;
        homeController.performSearch(text.toLowerCase());
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.012,
          horizontal: screenWidth * 0.02,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.grey[400], size: screenHeight * 0.024),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.016,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey[400], size: screenHeight * 0.024),
              onPressed: () => homeController.removeFromSearchHistory(text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(double screenHeight, double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
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
      ),
    );
  }

  Widget _buildTrendingItem(double screenHeight, String text, Color bgColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: screenHeight * 0.02,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: screenHeight * 0.016,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildModernTag(String text, Color bgColor) {
    return GestureDetector(
      onTap: () {
        final homeController = Get.find<HomeController>();
        homeController.performSearch(text.split(' ')[1]); // Enlève l'emoji
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04,
          vertical: Get.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: Get.height * 0.016,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildNoProductsMessage(double screenHeight, double screenWidth) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.04,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: screenHeight * 0.06,
            color: Colors.grey[500],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Aucun produit disponible",
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "Revenez plus tard pour découvrir nos nouveautés",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.016,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
