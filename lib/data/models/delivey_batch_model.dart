// To parse this JSON data, do
//
//     final deliveryBatchesResponse = deliveryBatchesResponseFromJson(jsonString);

import 'dart:convert';

DeliveryBatchesResponse deliveryBatchesResponseFromJson(String str) => DeliveryBatchesResponse.fromJson(json.decode(str));

String deliveryBatchesResponseToJson(DeliveryBatchesResponse data) => json.encode(data.toJson());

class DeliveryBatchesResponse {
    Data data;

    DeliveryBatchesResponse({
        required this.data,
    });

    factory DeliveryBatchesResponse.fromJson(Map<String, dynamic> json) => DeliveryBatchesResponse(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String batchNumber;
    String status;
    String deliveryMethod;
    DateTime arrivalDate;
    DateTime departureDate;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.batchNumber,
        required this.status,
        required this.deliveryMethod,
        required this.arrivalDate,
        required this.departureDate,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        batchNumber: json["batch_number"],
        status: json["status"],
        deliveryMethod: json["delivery_method"],
        arrivalDate: DateTime.parse(json["arrival_date"]),
        departureDate: DateTime.parse(json["departure_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "batch_number": batchNumber,
        "status": status,
        "delivery_method": deliveryMethod,
        "arrival_date": arrivalDate.toIso8601String(),
        "departure_date": departureDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
