import 'package:afrika_baba/modules/auth/views/on_boarding.dart';
import 'package:afrika_baba/providers/local_storage_provider.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToNextScreen());
  }

  Future<void> _navigateToNextScreen() async {
    final LocalStorageProvider localStorage = Get.find<LocalStorageProvider>();
    
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; 

    if (localStorage.isFirstLaunch()) {
      await localStorage.completeFirstLaunch();
      Get.off(() => const OnboardingScreen());
    } else {
      final token = localStorage.getToken();
      Get.offAllNamed(token?.isNotEmpty == true ? '/home' : '/firstlogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAppColor,
      body: Center(
        child: Image.asset(
          "assets/afrika_baba_logo.png",
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
