import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:afrika_baba/shared/themes/chart_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/data/models/my_order_response.dart';

class PayScreen extends StatelessWidget {
  
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 375;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(size.width * 0.04),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes commandes',
                    style: GoogleFonts.poppins(
                      fontSize: 20 * textScale,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                      children: [
                        _buildFilterChip('Tous', '', orderController, textScale),
                        SizedBox(width: size.width * 0.02),
                        _buildFilterChip('En attente', 'PENDING', orderController, textScale),
                        SizedBox(width: size.width * 0.02),
                        _buildFilterChip('En cours', 'IN_PROGRESS', orderController, textScale),
                        SizedBox(width: size.width * 0.02),
                        _buildFilterChip('Rejeté', 'REJECTED', orderController, textScale),
                        SizedBox(width: size.width * 0.02),
                        _buildFilterChip('Annulé', 'CANCELED', orderController, textScale),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => orderController.getMyOrders(),
                child: Obx(() {
                  final filteredOrders = _getFilteredOrders(orderController);
                  if (filteredOrders.isEmpty) {
                    return _buildEmptyState(size, textScale);
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(size.width * 0.04),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) => _buildOrderCard(
                      filteredOrders[index],
                      size,
                      textScale,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String status, OrderController controller, double textScale) {
    final isSelected = controller.selectedFilter.value == status;
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 14 * textScale,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        controller.selectedFilter.value = selected ? status : '';
      },
      backgroundColor: Colors.grey[100],
      selectedColor: textgrennColor,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  List<Order> _getFilteredOrders(OrderController orderController) {
    switch (orderController.selectedFilter.value) {
      case 'PENDING':
        return orderController.myOrdersPending;
      case 'REJECTED':
        return orderController.myOrdersRejected;
      case 'CANCELED':
        return orderController.myOrdersCanceled;
      case 'IN_PROGRESS':
        return orderController.myOrdersInProgress;
      default:
        return [
          ...orderController.myOrdersPending,
          ...orderController.myOrdersRejected,
          ...orderController.myOrdersCanceled,
          ...orderController.myOrdersInProgress,
        ];
    }
  }

  Widget _buildEmptyState(Size size, double textScale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Aucune commande trouvée',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, Size size, double textScale) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Order N° ${_truncateOrderNumber(order.orderNumber)}",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(getStatusLabel(order.status)),
              ],
            ),
            const SizedBox(height: 12),
            _buildOrderDetail("Quantité", "${order.orderItems.length} produits"),
            const SizedBox(height: 8),
            _buildOrderDetail("Total", "${order.totalPrice} FCFA"),
          ],
        ),
      ),
    );
  }

  String _truncateOrderNumber(String orderNumber) {
    const int maxLength = 10;
    if (orderNumber.length <= maxLength) {
      return orderNumber;
    }
    return '${orderNumber.substring(0, maxLength)}...';
  }

  Widget _buildOrderDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'En attente':
        return Colors.orange;
      case 'Rejeté':
        return Colors.red;
      case 'Annulé':
        return Colors.grey;
      case 'En cours':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'En attente';
      case 'REJECTED':
        return 'Rejeté';
      case 'CANCELED':
        return 'Annulé';
      case 'IN_PROGRESS':
        return 'En cours';
      default:
        return status;
    }
  }
}
