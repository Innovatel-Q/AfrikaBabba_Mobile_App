import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/orders/cart/controllers/cart_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/views/comment_product_screen.dart';  
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProduct extends StatefulWidget {
  final Product product;

  const DetailProduct({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
 CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final cartController = Get.find<CartController>();
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: width * 0.05),
          onPressed: () => Get.toNamed(AppRoutes.HOME)
        ),
        title: Text(
          'Détails produits',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height: height * 0.4,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    items: [widget.product.mainImageUrl ?? 'https://images.pexels.com/photos/28578770/pexels-photo-28578770/free-photo-of-des-lunettes-elegantes-sur-des-socles-blancs-artistiques.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',"https://images.pexels.com/photos/1044458/pexels-photo-1044458.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"].map((imageUrl) {
                      return SizedBox(
                        width: width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                            child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: SpinKitWave(color: btnColor)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    left: 10,
                    top: height * 0.2,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                      onPressed: () => carouselController.previousPage(),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: height * 0.2,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
                      onPressed: () => carouselController.nextPage(),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 20,
                  //   left: 0,
                  //   right: 0,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       _buildIconButton(Icons.camera_alt_outlined, () {}),
                  //       SizedBox(width: width * 0.05),
                  //       _buildIconButton(Icons.video_collection_outlined, () {}),
                  //       SizedBox(width: width * 0.05),
                  //       _buildIconButton(Icons.comment_outlined, () {}),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Catégorie',    
                                  style: TextStyle(color: btnColor),
                                ),
                                TextSpan(text: ' : ${widget.product.category.name}'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              widget.product.name,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prix',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                           '${formatPrice(widget.product.price)}F',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(60, 88, 191, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => CommentBottomSheet(
                            product: widget.product,
                                homeController: homeController,
                              ),
                            );
                        },  
                        child: Text(
                        '${widget.product.reviews.length} avis',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: btnColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          ),
                        ),
                      ), 
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _calculateAverageRating(widget.product.reviews).toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: Colors.black, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Livraison gratuite',
                        style: GoogleFonts.poppins(fontSize: 14,color: btnColor,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: btnColorgrey
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      cartController.addProduct(widget.product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: const Icon(Icons.shopping_cart, size: 24),
                    label: Text(
                      'Ajoutez au panier',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: btnColor, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 14),
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

class CommentBottomSheet extends StatelessWidget {

  final Product product;
  final HomeController homeController;
  const CommentBottomSheet({super.key, required this.product, required this.homeController});

  @override
  Widget build(BuildContext context) {
    homeController.getProductReviews(product.id);
    final width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Commentaire',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(color: textColor),
                  Expanded(
                    child: Obx(() {
                      final reviews = homeController.reviews;
                      return reviews.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun commentaire pour le moment',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: reviews.length,  
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              return buildComment(
                                context, 
                                '${review.user.lastname} ${review.user.firstname}',
                                formatRelativeTime(review.createdAt),
                                review.comment, 
                                review.rating, 
                                'https://s3-alpha-sig.figma.com/img/78e3/6caa/4371923441216e79dd881d663e52a49e?Expires=1727654400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=GyPM8vhdOmfbsXYZW7bgfggOyb2MGFxyUovQiGbRiDBg0NZTWBDt2MgrL16uATreAPbzayykHe1alx1dow0BMPlNxbpKAq2A4F4v99Fo7GrwkIaaVFrjcnnIgFI6fP-eotUn2gVbfqkDT6GtBpmGGeySEdOriO0P~~uXFDEKsPfTMEfAnKDgwepN6RFNGxeuW5QqTpVzM9FsSyhLkyx-mjFMgFxS~B-B20HRj2A5Dh7visAqThrx21QyYbVtPCVq5DFsurIW~fUoyQWhFsbNL6s-yyj7Vz17UyrLR4AfV0Lse62sffpCp7sICi3WH--xB6Pjbq2EJApgR7gI7mKv1A__',
                                review.user.id,
                                review.id
                              );
                            },
                          );
                    }),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    Get.to(AddCommentScreen(product: product));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border:
                          Border.all(color: Colors.red, width: width * 0.008),
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    child:
                        Icon(Icons.add, color: Colors.red, size: width * 0.05),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildComment(BuildContext context, String name, String time,
      String comment, int rating, String avatarUrl,int userId, int commentId) {

    final user = Get.find<LocalStorageProvider>().getUser();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 30,
            backgroundImage: NetworkImage(
                "https://s3-alpha-sig.figma.com/img/78e3/6caa/4371923441216e79dd881d663e52a49e?Expires=1727654400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=GyPM8vhdOmfbsXYZW7bgfggOyb2MGFxyUovQiGbRiDBg0NZTWBDt2MgrL16uATreAPbzayykHe1alx1dow0BMPlNxbpKAq2A4F4v99Fo7GrwkIaaVFrjcnnIgFI6fP-eotUn2gVbfqkDT6GtBpmGGeySEdOriO0P~~uXFDEKsPfTMEfAnKDgwepN6RFNGxeuW5QqTpVzM9FsSyhLkyx-mjFMgFxS~B-B20HRj2A5Dh7visAqThrx21QyYbVtPCVq5DFsurIW~fUoyQWhFsbNL6s-yyj7Vz17UyrLR4AfV0Lse62sffpCp7sICi3WH--xB6Pjbq2EJApgR7gI7mKv1A__"), 
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 15,
                          );
                        }),
                        const SizedBox(width: 5),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  comment,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                if (user!.id == userId)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.to(() => AddCommentScreen(product: product, edit: true,));   
                        },
                        child: Text(
                          'Modifier',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          homeController.deleteComment(commentId, product.id);
                        },
                        child: Text(
                          'Supprimer',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} jours';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} heures';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return '${difference.inSeconds} secondes';
    }
  }
}
