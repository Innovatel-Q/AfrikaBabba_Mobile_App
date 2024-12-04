import 'package:afrika_baba/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  static const _pageSize = 10;

  final PagingController<int, Product> _pagingController =
  PagingController(firstPageKey: 1);
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _homeController.loadMoreProducts(page: pageKey);
      print('Products loaded for page $pageKey: ${newItems.length} items');

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
        print('Last page reached with ${newItems.length} items');
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
        print('Loading next page: $nextPageKey');
      }
    } catch (error) {
      print('Error loading products: $error');
      _pagingController.error = error;
    }
  }


  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: btnColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tous les produits',
          style: GoogleFonts.poppins(
            fontSize: screenHeight * 0.020,
            color: btnColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(() => _pagingController.refresh()),
                  child: PagedGridView<int, Product>(
                    pagingController: _pagingController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: screenWidth * 0.025,
                      mainAxisSpacing: screenWidth * 0.025,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<Product>(
                      animateTransitions: true,
                      itemBuilder: (context, product, index) => GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product),
                        child: ProductCard(
                          product: product,
                          imageHeight: screenHeight * 0.12,
                          imageWidth: screenWidth * 0.15,
                        ),
                      ),
                      firstPageProgressIndicatorBuilder: (_) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SpinKitChasingDots(
                              color: btnColor,
                              size: 25,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Chargement des produits...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      newPageProgressIndicatorBuilder: (_) => Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenHeight * 0.02),
                          child: const CircularProgressIndicator(
                            color: btnColor,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: _buildErrorIndicator,
                      noItemsFoundIndicatorBuilder: _buildEmptyIndicator,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(double screenHeight, double screenWidth) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.5,
          crossAxisSpacing: screenWidth * 0.025,
          mainAxisSpacing: screenWidth * 0.025,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight * 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.12,
                  width: double.infinity,
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
        },
      ),
    );
  }

  Widget _buildErrorIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Une erreur est survenue',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _pagingController.refresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Réessayer',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyIndicator(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucun produit disponible',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

}
