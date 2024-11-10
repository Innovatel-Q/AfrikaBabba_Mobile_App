class MyOrderResponse {
  List<Order> orders;
  Links? links;
  Meta? meta;

  MyOrderResponse({required this.orders, this.links, this.meta});

  factory MyOrderResponse.fromJson(Map<String, dynamic> json) {
    return MyOrderResponse(
      orders: (json['data'] as List?)?.map((i) => Order.fromJson(i)).toList() ?? [],
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class Order {
  int id;
  String orderNumber;
  User? user;
  double totalPrice;
  String status;
  double? deliveryCost;
  String? deliveryMethod;
  String? batch;
  List<OrderItem> orderItems;
  List<dynamic> payments;
  List<dynamic> refundRequests;
  String? createdAt;
  String? updatedAt;

  Order({
    required this.id,
    required this.orderNumber,
    this.user,
    required this.totalPrice,
    required this.status,
    this.deliveryCost,
    this.deliveryMethod,
    this.batch,
    required this.orderItems,
    required this.payments,
    required this.refundRequests,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'UNKNOWN',
      deliveryCost: json['delivery_cost'] != null ? (json['delivery_cost'] as num).toDouble() : null,
      deliveryMethod: json['delivery_method'],
      batch: json['batch'],
      orderItems: (json['order_items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList() ?? [],
      payments: json['payments'] ?? [],
      refundRequests: json['refund_requests'] ?? [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class User {
  int id;
  String firstname;
  String lastname;
  String phoneNumber;
  String? adresse;
  String? avatar;
  String role;
  String email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String country;
  int status;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    this.adresse,
    this.avatar,
    required this.role,
    required this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.country,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      adresse: json['adresse'],
      avatar: json['avatar'],
      role: json['role'] ?? 'UNKNOWN',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      country: json['country'] ?? 'UNKNOWN',
      status: json['status'] ?? 0,
    );
  }
}

class OrderItem {
  int id;
  int orderId;
  String orderItemsCode;
  int productId;
  int quantity;
  int shopId;
  int forwarderId;
  String? status;
  String? statusTransitaire;
  String? deletedAt;
  double price;
  String? createdAt;
  String? updatedAt;
  String fraisInterne;
  String destinationCountry;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.orderItemsCode,
    required this.productId,
    required this.quantity,
    required this.shopId,
    required this.forwarderId,
    this.status,
    this.statusTransitaire,
    this.deletedAt,
    required this.price,
    this.createdAt,
    this.updatedAt,
    required this.fraisInterne,
    required this.destinationCountry,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      orderItemsCode: json['order_items_code'] ?? '',
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      forwarderId: json['forwarder_id'] ?? 0,
      status: json['status'],
      statusTransitaire: json['status_transitaire'],
      deletedAt: json['deleted_at'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      fraisInterne: json['frais_interne'] ?? '0.00',
      destinationCountry: json['destination_country'] ?? '',
    );
  }
}



class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<PageLink> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      from: json['from'],
      lastPage: json['last_page'],
      links: (json['links'] as List?)?.map((i) => PageLink.fromJson(i)).toList() ?? [], // Gestion du null
      path: json['path'],
      perPage: json['per_page'],
      to: json['to'],
      total: json['total'],
    );
  }
}

class PageLink {
  String? url;
  String label;
  bool active;

  PageLink({this.url, required this.label, required this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
