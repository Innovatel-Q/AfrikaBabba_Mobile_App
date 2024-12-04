import 'package:afrika_baba/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/product_model.dart';
import '../../../providers/local_storage_provider.dart';
import '../../../shared/themes/chart_color.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

import 'comment_product_screen.dart';

class CommentBottomSheet extends StatelessWidget {

  final Product product;
  final HomeController homeController;
  const CommentBottomSheet({super.key, required this.product, required this.homeController});

  @override
  Widget build(BuildContext context) {
    homeController.getProductReviews(product.id);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Barre de poignée
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                width: width * 0.15,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // En-tête
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Avis clients',
                      style: GoogleFonts.poppins(
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: textgrennColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.005,
                          ),
                          child: Obx(() => Text(
                            '${homeController.reviews.length} avis',
                            style: GoogleFonts.poppins(
                              fontSize: height * 0.016,
                              color: textgrennColor,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                        ),
                        SizedBox(width: width * 0.02),
                        IconButton(
                          onPressed: () {
                           Get.toNamed(AppRoutes.COMMENT_PRODUCT_SCREEN, arguments: product);
                          },
                          icon: Icon(
                            Icons.add_comment_outlined,
                            color: textgrennColor,
                            size: height * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Liste des commentaires
              Expanded(
                child: Obx(() {
                  final reviews = homeController.reviews;
                  return reviews.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: width * 0.15,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: height * 0.02),
                              Text(
                                'Soyez le premier à donner votre avis',
                                style: GoogleFonts.poppins(
                                  fontSize: height * 0.016,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          controller: controller,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                            vertical: height * 0.02,
                          ),
                          itemCount: reviews.length,
                          separatorBuilder: (context, index) => Divider(
                            height: height * 0.04,
                            color: Colors.grey[200],
                          ),
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
                              review.id,
                            );
                          },
                        );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildComment(BuildContext context, String name, String time,
      String comment, int rating, String avatarUrl, int userId, int commentId) {
    final user = Get.find<LocalStorageProvider>().getUser();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: width * 0.12,
                height: width * 0.12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: height * 0.016,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: height * 0.02,
                          );
                        }),
                        SizedBox(width: width * 0.02),
                        Text(
                          time,
                          style: GoogleFonts.poppins(
                            fontSize: height * 0.014,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.015),
          Text(
            comment,
            style: GoogleFonts.poppins(
              fontSize: height * 0.015,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          if (user!.id == userId)
            Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButton.icon(
                  //   onPressed: () {
                  //     Get.to(() => AddCommentScreen(product: product, edit: true));
                  //   },
                  //   icon: Icon(
                  //     Icons.edit_outlined,
                  //     size: height * 0.02,
                  //     color: textgrennColor,
                  //   ),
                  //   label: Text(
                  //     'Modifier',
                  //     style: GoogleFonts.poppins(
                  //       color: textgrennColor,
                  //       fontSize: height * 0.014,
                  //     ),
                  //   ),
                  // ),
                  TextButton.icon(
                    onPressed: () {
                      homeController.deleteComment(commentId, product.id);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: height * 0.02,
                      color: Colors.red[400],
                    ),
                    label: Text(
                      'Supprimer',
                      style: GoogleFonts.poppins(
                        color: Colors.red[400],
                        fontSize: height * 0.014,
                      ),
                    ),
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
