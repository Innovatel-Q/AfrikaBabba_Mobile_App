import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/home/views/detail_product.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/bottom_navigation_bar.dart';
import 'package:afrika_baba/shared/widgets/product_custom/build_tag.dart';
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
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.03),
          child: Text(
            'Recherche',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.025,
              color: btnColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.002,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            color: Colors.grey, size: screenHeight * 0.03),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TextField(
                            controller: homeController.value,
                            onChanged: (value) => homeController
                                .onSearchChanged(value.toLowerCase()),
                            onSubmitted: (value) =>
                                homeController.performSearch(value),
                            decoration: InputDecoration(
                              hintText: "Rechercher un produit",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.02,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Obx(() {
                    return homeController.searchQuery.value.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(homeController.searchHistory.isNotEmpty)
                                Text(
                                  "Historique",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenHeight * 0.018,
                                    color: textColor,
                                  ),
                                ),
                              if(homeController.searchHistory.isNotEmpty)
                              GestureDetector(
                                  onTap: () {
                                    homeController.clearSearchHistory();
                                  },
                                  child: Text(
                                    "Effacez tout",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenHeight * 0.018,
                                      color: btnColor,
                                      fontWeight: FontWeight.bold,
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
                            if (homeController.searchHistory.isNotEmpty)
                              ...homeController
                                  .searchHistory
                                  .map((historyItem) => _buildSearchHistoryItem(
                                      historyItem,
                                      screenHeight,
                                      screenWidth,
                                      homeController,
                                      localStorageProvider))
                                  .toList(),
                            SizedBox(height: screenHeight * 0.025),
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
                              spacing: screenWidth * 0.02,
                              runSpacing: screenHeight * 0.01,
                              children: const [
                                BuildTag("Mixeur"),
                                BuildTag("Pc gamer"),
                                BuildTag("Cosmétique"),
                                BuildTag("Mode"),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Divider(
                                height: screenHeight * 0.04,
                                thickness: 10,
                                color: textgray),
                            SizedBox(height: screenHeight * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.025),
                                  child: Text("Pour Vous",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.018,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: screenWidth * 0.04),
                                  child: Text(
                                    "Voir tout",
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
                              itemCount:
                                  homeController.products.isEmpty ? 6 : 6,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.5,
                                crossAxisSpacing: screenWidth * 0.025,
                              ),
                              itemBuilder: (context, index) {
                                if (homeController.products.isEmpty) {
                                  return _buildSkeletonLoader(
                                      screenHeight, screenWidth);
                                }
                                final product = homeController.products[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(DetailProduct(
                                      product: product,
                                    ));
                                  },
                                  child: ProductCard(
                                    product: product,
                                    imageHeight: screenHeight * 0.12,
                                    imageWidth: screenWidth * 0.28,
                                  ),
                                );
                              },
                            ),
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
                              return _buildSearchHistoryItem(suggestion,
                                  screenHeight, screenWidth, homeController, localStorageProvider);
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
              if (homeController.searchQuery.value.isEmpty && MediaQuery.of(context).viewInsets.bottom == 0) {
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomBottomNavigationBar(selectedIndex: 3),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistoryItem(String text, double screenHeight,
      double screenWidth, HomeController homeController, LocalStorageProvider localStorageProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                homeController.performSearch(text);
              },
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.018),
              )),
          GestureDetector(
            onTap: () {
              homeController.removeFromSearchHistory(text);
            },
            child: Image.asset("assets/icone grup.png",
                height: screenHeight * 0.02),
          ),
        ],
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
}
