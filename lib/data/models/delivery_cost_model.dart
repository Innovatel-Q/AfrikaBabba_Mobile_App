import 'dart:convert';

class DeliveryCostModel {
  final int id;
  final String? pays;  // Changed to nullable
  final int? costSea;  // Changed to nullable
  final int? costAir;  // Changed to nullable
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryCostModel({
    required this.id,
    this.pays,  // Made optional
    this.costSea,  // Made optional
    this.costAir,  // Made optional
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryCostModel.fromJson(Map<String, dynamic> json) {
    return DeliveryCostModel(
      id: json['id'],
      pays: json['pays'],  // No need for null check, as it's already nullable
      costSea: json['cost_sea'],  // No need for null check, as it's already nullable
      costAir: json['cost_air'],  // No need for null check, as it's already nullable
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pays': pays,
      'cost_sea': costSea,
      'cost_air': costAir,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class DeliveryCostResponse {
  final List<DeliveryCostModel> data;
  final Map<String, dynamic> links;
  final Map<String, dynamic> meta;

  DeliveryCostResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory DeliveryCostResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryCostResponse(
      data: (json['data'] as List).map((item) => DeliveryCostModel.fromJson(item)).toList(),
      links: json['links'],
      meta: json['meta'],
    );
  }
}

DeliveryCostResponse deliveryCostResponseFromJson(String str) => DeliveryCostResponse.fromJson(json.decode(str));

String deliveryCostResponseToJson(DeliveryCostResponse data) => json.encode({
  'data': data.data.map((item) => item.toJson()).toList(),
  'links': data.links,
  'meta': data.meta,
});