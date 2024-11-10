import 'package:afrika_baba/data/models/product_model.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
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
  // ignore: unused_field
  int _rating = 0;
  final homeController = Get.find<HomeController>();
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          widget.edit
              ? "Modifier votre commentaire"
              : "Ajouter votre commentaire",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: screenHeight * 0.020,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Note",
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.02,
                color: Colors.black,
              ),
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating.toInt();
                });
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Avis",
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.02,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Entrez votre commentaire ici",
              ),
            ),
            const SizedBox(height: 100),
            CustomButton(
              onPressed: () async {
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
                    Get.snackbar('Erreur', 'Aucune donnée à modifier',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                } else {
                  if (data.isNotEmpty) {
                    data["product_id"] = widget.product.id;
                    _commentController.clear();
                    await homeController.addComment(widget.product.id, data);
                  } else {
                    Get.snackbar('Erreur', 'Le commentaire est requis',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                }
              },
              color: textgrennColor,
              text: widget.edit
                  ? "Modifier votre commentaire"
                  : "Ajouter votre commentaire",
            ),
          ],
        ),
      ),
    );
  }
}
