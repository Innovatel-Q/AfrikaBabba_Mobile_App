// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:afrika_baba/data/models/product_model.dart';
import 'package:get/get.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
    int id;
    Product product;
    RxInt quantity;

    CartModel({
        required this.id,
        required this.product,
        required this.quantity,
    });

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        product: Product.fromJson(json["product"]),
        quantity: RxInt(json["quantity"]),
    );

    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'product': product.toJson(), // Assurez-vous que Product a aussi une méthode toJson()
            'quantity': quantity.value,
        };
    }
}



