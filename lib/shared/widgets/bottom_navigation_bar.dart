import 'package:afrika_baba/routes/app_routes.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/modules/home/views/search_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  int selectedIndex;
  CustomBottomNavigationBar({super.key, required this.selectedIndex});
  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
@override
Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(
            bottom: 5,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: textColorSecond,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[500],
            showUnselectedLabels: false,
            currentIndex: widget.selectedIndex,
              onTap: (index) {
              setState(() {
                widget.selectedIndex = index;
              }); 
              switch (index) {
                case 0:
                  Get.toNamed(AppRoutes.HOME);
                  break;
                case 1:
                  Get.toNamed(AppRoutes.CHAT_SCREEN);
                  break;
                case 2:
                  Get.toNamed(AppRoutes.PAY_SCREEN);
                  break;
                case 3:
                  Get.to(const SearchProduct());
                  break;
                case 4:
                  Get.toNamed(AppRoutes.PROFILE);
                  break;
                default:
                  Get.toNamed('/publish');
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                 widget.selectedIndex == 0 ? 'assets/home.png' : 'assets/Vector.png',
                  height: 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  widget.selectedIndex == 1 ? 'assets/groupe_icone_2/Group 38.png' : 'assets/messages.png',
                  height: 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  widget.selectedIndex == 2 ? 'assets/groupe_icone_2/Group 1.png' : 'assets/panier.png',
                  height: 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  widget.selectedIndex == 3 ? 'assets/groupe_icone_2/Group19.png' : 'assets/recherche.png',
                  height: 24,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  widget.selectedIndex == 4 ? 'assets/groupe_icone_2/Group 18.png' : 'assets/profil.png',
                  height: 24,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

}
