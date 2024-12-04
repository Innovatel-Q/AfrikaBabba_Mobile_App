import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCommentScreen extends StatefulWidget {
  final Product product;
  final bool edit;
  const AddCommentScreen({super.key, required this.product, this.edit = false});

  @override
  // ignore: library_private_types_in_public_api
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  int _rating = 0;
  final homeController = Get.find<HomeController>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialiser les valeurs si on est en mode édition
    if (widget.edit) {
      // Chercher le commentaire de l'utilisateur pour ce produit
      final userReview = homeController.reviews.firstWhereOrNull(
        (review) => review.user.id == Get.find<LocalStorageProvider>().getUser()?.id
      );
      
      if (userReview != null) {
        setState(() {
          _rating = userReview.rating;
          _commentController.text = userReview.comment;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.edit ? "Modifier votre avis" : "Ajouter votre avis",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: screenHeight * 0.022,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(screenWidth * 0.04),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Votre évaluation",
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: screenWidth * 0.08,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating.toInt();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Votre commentaire",
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    controller: _commentController,
                    maxLines: 5,
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.016,
                      decoration: TextDecoration.none,
                      height: 1.5,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(screenWidth * 0.04),
                      hintText: "Partagez votre expérience avec ce produit...",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: screenHeight * 0.016,
                        decoration: TextDecoration.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: textgrennColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            
            Map<String, dynamic> data = {};
            if (_rating != 0) {
              data["rating"] = _rating;
            }
            if (_commentController.text.isNotEmpty) {
              data["comment"] = _commentController.text;
            }
            if (widget.edit) {
              if (data.isNotEmpty) {
                await homeController.editComment(widget.product.id, data);
              } else {
                Get.snackbar('Opps', 'Aucune donnée à modifier',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            } else {
              if (data.isNotEmpty) {
                data["product_id"] = widget.product.id;
                _commentController.clear();
                await homeController.addComment(widget.product.id, data);
              } else {
                Get.snackbar('Opps', 'Le commentaire est requis',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: textgrennColor,
            minimumSize: Size(double.infinity, screenHeight * 0.06),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            widget.edit ? "Modifier l'avis" : "Publier l'avis",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
