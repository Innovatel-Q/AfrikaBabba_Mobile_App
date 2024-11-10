import 'package:afrika_baba/modules/orders/cart/views/%20delivered_screen.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:afrika_baba/modules/orders/cart/views/no_pay_screnn.dart';
import 'package:afrika_baba/modules/orders/cart/views/pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          'Votre panier',
          style: GoogleFonts.poppins(
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
            color: btnColor
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: height * 0.02),
          // TabBar Section
          TabBar(
            controller: _tabController,
            labelColor: btnColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: textgrennColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Non payé'),
              Tab(text: 'Payé'),
              Tab(text: 'Livrés'),
            ],
          ),
          SizedBox(height: height * 0.02),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                NoPayScreen(),
                const PayScreen(),
               DeliveryScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  

}
