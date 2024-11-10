import 'package:afrika_baba/modules/orders/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:afrika_baba/data/models/my_order_response.dart';

class PayScreen extends StatelessWidget {
  
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              Text(
                'Mes commandes',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.02),
              _buildFilterChips(orderController),
              SizedBox(height: height * 0.02),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await orderController.getMyOrders();
                  },
                  child: Obx(() {
                    final filteredOrders = _getFilteredOrders(orderController);
                    if (filteredOrders.isEmpty) {
                      return _buildEmptyState();
                    } else {
                      return _buildOrderList(filteredOrders);
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(OrderController orderController) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Tous', '', orderController),
          const SizedBox(width: 8),
          _buildFilterChip('En attente', 'PENDING', orderController),
          const SizedBox(width: 8),
          _buildFilterChip('Rejeté', 'REJECTED', orderController),
          const SizedBox(width: 8),
          _buildFilterChip('Annulé', 'CANCELED', orderController),
          const SizedBox(width: 8),
          _buildFilterChip('En cours', 'IN_PROGRESS', orderController),
        ],
      ),
    ));
  }

  Widget _buildFilterChip(String label, String status, OrderController orderController) {
    final isSelected = orderController.selectedFilter.value == status;
    return FilterChip(
      label: Text(label, style: GoogleFonts.poppins(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      selected: isSelected,
      onSelected: (bool selected) {
        orderController.selectedFilter.value = selected ? status : '';
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(Get.context!).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
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
                _buildOrderDetail("Quantité", "${order.orderItems.length} items"),
                const SizedBox(height: 8),
                _buildOrderDetail("Total", "${order.totalPrice} FCFA"),
              ],
            ),
          ),
        );
      },
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
