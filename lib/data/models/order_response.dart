// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) => OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
    Order order;

    OrderResponse({
        required this.order,
    });

    factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        order: Order.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": order.toJson(),
    };
}

class Order {
    int id;
    String orderNumber;
    User user;
    String totalPrice;
    dynamic status;
    String deliveryCost;
    String deliveryMethod;
    dynamic batch;
    List<dynamic> orderItems;
    List<dynamic> payments;
    List<dynamic> refundRequests;
    DateTime createdAt;
    DateTime updatedAt;

      Order({
        required this.id,
        required this.orderNumber,
        required this.user,
        required this.totalPrice,
        required this.status,
        required this.deliveryCost,
        required this.deliveryMethod,
        required this.batch,
        required this.orderItems,
        required this.payments,
        required this.refundRequests,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        orderNumber: json["order_number"],
        user: User.fromJson(json["user"]),
        totalPrice: json["total_price"],
        status: json["status"],
        deliveryCost: json["delivery_cost"],
        deliveryMethod: json["delivery_method"],
        batch: json["batch"],
        orderItems: List<dynamic>.from(json["order_items"].map((x) => x)),
        payments: List<dynamic>.from(json["payments"].map((x) => x)),
        refundRequests: List<dynamic>.from(json["refund_requests"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_number": orderNumber,
        "user": user.toJson(),
        "total_price": totalPrice,
        "status": status,
        "delivery_cost": deliveryCost,
        "delivery_method": deliveryMethod,
        "batch": batch,
        "order_items": List<dynamic>.from(orderItems.map((x) => x)),
        "payments": List<dynamic>.from(payments.map((x) => x)),
        "refund_requests": List<dynamic>.from(refundRequests.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class User {
    int id;
    String firstname;
    String lastname;
    String phoneNumber;
    dynamic adresse;
    dynamic avatar;
    String role;
    String email;
    DateTime emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;
    dynamic country;
    int status;

    User({
        required this.id,
        required this.firstname,
        required this.lastname,
        required this.phoneNumber,
        required this.adresse,
        required this.avatar,
        required this.role,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.country,
        required this.status,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phoneNumber: json["phone_number"],
        adresse: json["adresse"],
        avatar: json["avatar"],
        role: json["role"],
        email: json["email"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        country: json["country"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "phone_number": phoneNumber,
        "adresse": adresse,
        "avatar": avatar,
        "role": role,
        "email": email,
        "email_verified_at": emailVerifiedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "country": country,
        "status": status,
    };
}
