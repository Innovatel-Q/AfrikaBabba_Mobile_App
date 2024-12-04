import 'package:intl/intl.dart';

import '../../data/models/product_model.dart';

class Utils {
  static String formatDate(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }
}