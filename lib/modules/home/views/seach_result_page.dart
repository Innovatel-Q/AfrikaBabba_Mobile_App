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

class SearchResultPage extends StatefulWidget {

  const SearchResultPage({super.key, required this.query, this.category});
  final String query;
  final int? category;


  @override
  // ignore: library_private_types_in_public_api
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 1);
  final HomeController homeController = Get.find<HomeController>();


  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _fetchPage(1);
    super.initState();

  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }


  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = widget.query.isNotEmpty ?  
      await homeController.loadMoreProductsForSearch(widget.query, null, page: pageKey) : 
      await homeController.loadMoreProductsForSearch(null, widget.category, page: pageKey);
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
          'Résultat de la recherche',
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
          if (homeController.isLoading.value) {
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
                    Get.to(DetailProduct(product: product));
                  },
                  child: ProductCard(
                    product: product,
                    imageHeight: height * 0.12,
                    imageWidth: width * 0.28,
                  ),
                );
              },
              firstPageProgressIndicatorBuilder: (_) => _buildSkeletonLoader(width, height),
              newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (_) => Center(
                child: Text('Aucun produit trouvé', style: GoogleFonts.poppins()),
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
