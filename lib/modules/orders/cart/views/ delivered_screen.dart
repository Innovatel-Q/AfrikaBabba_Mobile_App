// ignore: file_names
import 'package:afrika_baba/data/models/my_order_response.dart';
import 'package:afrika_baba/modules/home/controllers/home_controller.dart';
import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() {
                if (orderController.myOrdersDelivered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          size: width * 0.2,
                          color: Colors.grey,
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Aucune commande livrée',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          'Vos commandes livrées apparaîtront ici',
                          style: TextStyle(
                            fontSize: width * 0.04,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await orderController.getMyOrders();
                    },
                    child: ListView.builder(
                      itemCount: orderController.myOrdersDelivered.length,
                      itemBuilder: (context, index) {
                        final order = orderController.myOrdersDelivered[index];
                        return OrderCard(
                            order: order, width: width, height: height);
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final double width;
  final double height;

  const OrderCard({
    super.key,
    required this.order,
    required this.width,
    required this.height,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  void initState() {
    super.initState();
    // Préchargement des images au chargement
    final homeController = Get.find<HomeController>();
    for (var item in widget.order.orderItems) {
      homeController.getProductImageById(item.product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Card(
      margin: EdgeInsets.only(bottom: widget.height * 0.02),
      child: Padding(
        padding: EdgeInsets.all(widget.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.height * 0.1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.order.orderItems.length,
                itemBuilder: (context, index) {
                  final item = widget.order.orderItems[index];
                  return Container(
                    margin: EdgeInsets.only(right: widget.width * 0.02),
                    width: widget.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder<String?>(
                      future:
                          homeController.getProductImageById(item.product.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SpinKitWave(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            size: 20,
                          );
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Icon(Icons.error);
                        }
                        return CachedNetworkImage(
                          imageUrl: snapshot.data!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SpinKitWave(
                            color: Colors.black,
                            size: 20,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: widget.height * 0.02),
            // Informations sur la commande
            Text(
              'Commande #${widget.order.orderNumber}',
              style: GoogleFonts.poppins(
                fontSize: widget.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: widget.height * 0.01),
            buildInfoRow(
                "Date",
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(widget.order.createdAt.toString())),
                widget.width),
            buildInfoRow(
                "Prix total", '${widget.order.totalPrice} FCFA', widget.width),
            buildInfoRow("Statut", "Livré", widget.width,
                isStatus: true),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value, double width,
      {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              color: textColor,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: width * 0.035,
              color: isStatus ? Colors.green : Colors.black,
              fontWeight: isStatus ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
