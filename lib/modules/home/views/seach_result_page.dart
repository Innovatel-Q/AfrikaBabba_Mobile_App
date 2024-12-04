import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/search_result_controller.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key, required this.query, this.category});
  final String query;
  final int? category;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<SearchResultController>(
      init: SearchResultController(query: query, category: category),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.0),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: btnColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Résultats de recherche',
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.020,
                color: btnColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.refreshProducts,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: controller.products.isEmpty
                    ? _buildEmptyState(screenHeight)
                    : GridView.builder(
                  controller: controller.scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: screenWidth * 0.025,
                    mainAxisSpacing: screenWidth * 0.025,
                  ),
                  itemCount: controller.products.length + (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.products.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: const CircularProgressIndicator(color: btnColor),
                        ),
                      );
                    }
                    final product = controller.products[index];
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: screenHeight * 0.15,
            color: btnColor.withOpacity(0.7),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Aucun résultat trouvé',
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.02,
              color: btnColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Essayez avec d\'autres mots-clés',
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
}


