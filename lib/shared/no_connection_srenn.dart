import 'package:afrika_baba/services/connectivity_service.dart';
import 'package:afrika_baba/shared/widgets/buttons/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConnectivityController connectivityController = Get.find<ConnectivityController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/no_connect.png', width: screenWidth * 0.6),
        
            Column(
              children: [
                Text(
                  'Ooops !',
                  style: GoogleFonts.poppins(fontSize: 25, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Il semble qu\'il y ait un problème avec votre '
                    'connexion internet. Veuillez vous connecter '
                    'à Internet et redémarrer Sphère.',
                    style: GoogleFonts.poppins(fontSize: 13, color: const Color.fromRGBO(201, 201, 201, 1)),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: CustomButton(
                color: const Color.fromRGBO(5, 5, 5, 1),
                text: 'Réessayer',
                onPressed: () {
                  connectivityController.checkConnectivity();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}