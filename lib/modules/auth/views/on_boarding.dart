import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isFinished = false;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Image.asset(
                      'assets/groupe onboarding.png'), // Add your image asset here
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bienvenue sur ',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text: 'Afrikababa',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColorSecond,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(
                      text:
                          ', votre destination en ligne pour une vaste gamme de produits de qualité directement importés de Chine. Nous sommes fiers de vous offrir une expérience d\'achat exceptionnelle, où la diversité, l\'innovation et les prix compétitifs se rencontrent.',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: textColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: SwipeableButtonView(
                  buttonText: 'Switchez pour explorer', 
                  buttontextstyle: const TextStyle(
                    fontSize: 13,
                    color: backgroundAppColor,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  buttonWidget: Container(
                  ),
                  activeColor: btnColor,
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        isFinished = true;
                      });
                    });
                  },
                  onFinish: () async {
                    await Get.offAllNamed(AppRoutes.FIRSTLOGIN);
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}