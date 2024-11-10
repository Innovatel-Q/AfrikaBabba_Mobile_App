import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/home/views/detail_product.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/product_custom/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart'; 

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {

  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 1);
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _fetchPage(1);
  }

  Future<void> _fetchPage(int pageKey) async {
    print('Starting _fetchPage with pageKey: $pageKey');
    try {
      print('Calling homeController.loadMoreProducts');
      final newItems = await homeController.loadMoreProducts(page: pageKey);
      print('Received ${newItems.length} new items');

      final isLastPage = newItems.isEmpty;
      print('Is this the last page? $isLastPage');

      if (isLastPage) {
        print('Appending last page');
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        print('Appending page with nextPageKey: $nextPageKey');
        _pagingController.appendPage(newItems, nextPageKey);
      }
      print('_fetchPage completed successfully');
    } catch (error) {
      print('Error in _fetchPage: $error');
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: width * 0.05),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tous les produits',
          style: GoogleFonts.poppins(
            fontSize: width * 0.040,
            fontWeight: FontWeight.bold,
            color: btnColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Obx(() {
          if (homeController.isLoading.value && homeController.initialLoading.value) {
            return _buildSkeletonLoader(width, height);
          }
          return PagedGridView<int, Product>(
            pagingController: _pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.5,
              crossAxisSpacing: width * 0.025,
            ),
            builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, product, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailProduct(product: product));
                  },
                  child: ProductCard(
                    product: product,
                    imageHeight: height * 0.12,
                    imageWidth: width * 0.28,
                  ),
                );
              },
              newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Text('No products found'),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSkeletonLoader(double width, double height) {
    return GridView.builder(
      itemCount: 12, 
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.5,
        crossAxisSpacing: width * 0.025,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.12,
                width: width * 0.28,
                color: Colors.white,
              ),
              SizedBox(height: height * 0.01),
              Container(
                height: height * 0.02,
                width: width * 0.2,
                color: Colors.white,
              ),
              SizedBox(height: height * 0.005),
              Container(
                height: height * 0.015,
                width: width * 0.15,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
