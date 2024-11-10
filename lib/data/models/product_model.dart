import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  List<Product> data;
  Links links;
  Meta meta;

  ProductResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        data: List<Product>.from(
            json["data"].map((x) => Product.fromJson(x)) ?? []),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Product {
  int id;
  int shopId;
  int categoryId;
  String sku;
  String name;
  int price;
  String? mainImageUrl;
  String? videoUrl;
  String description;
  double productWeight;
  ProductDimensions productDimensions;
  String status;
  int available;
  DateTime createdAt;
  DateTime updatedAt;
  Shop shop;
  Category category;
  List<ProductMedia> productMedia;
  List<Review> reviews;

  Product({
    required this.id,
    required this.shopId,
    required this.categoryId,
    required this.sku,
    required this.name,
    required this.price,
    this.mainImageUrl,
    this.videoUrl,
    required this.description,
    required this.productWeight,
    required this.productDimensions,
    required this.status,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
    required this.shop,
    required this.category,
    required this.productMedia,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? 0,
        shopId: json["shop_id"] ?? 0,
        categoryId: json["category_id"] ?? 0,
        sku: json["sku"] ?? '',
        name: json["name"] ?? '',
        price: json["price"] ?? 0,
        mainImageUrl: json["main_image_url"],
        videoUrl: json["video_url"],
        description: json["description"] ?? '',
        productWeight: (json["product_weight"] ?? 0.0).toDouble(),
        productDimensions: ProductDimensions.fromJson(json["product_dimensions"]),
        status: json["status"] ?? 'inactive',
        available: json["available"] ?? 0,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
        shop: Shop.fromJson(json["shop"]),
        category: Category.fromJson(json["category"]),
        productMedia: List<ProductMedia>.from(
            json["product_media"]?.map((x) => ProductMedia.fromJson(x)) ?? []),
        reviews: List<Review>.from(
            json["reviews"]?.map((x) => Review.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shop_id": shopId,
        "category_id": categoryId,
        "sku": sku,
        "name": name,
        "price": price,
        "main_image_url": mainImageUrl,
        "video_url": videoUrl,
        "description": description,
        "product_weight": productWeight,
        "product_dimensions": productDimensions.toJson(),
        "status": status,
        "available": available,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "shop": shop.toJson(),
        "category": category.toJson(),
        "product_media": List<dynamic>.from(productMedia.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class ProductDimensions {
  double height;
  double width;
  double length;

  ProductDimensions({
    required this.height,
    required this.width,
    required this.length,
  });

  factory ProductDimensions.fromJson(Map<String, dynamic> json) =>
      ProductDimensions(
        height: (json["height"] ?? 0.0).toDouble(),
        width: (json["width"] ?? 0.0).toDouble(),
        length: (json["length"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
        "length": length,
      };
}

class Shop {
  int id;
  int userId;
  String companyName;
  String salesManagerName;
  String companyRegistration;
  String businessLicense;
  String phoneNumber;
  String emailAddress;
  String? logo;
  String? banner;
  dynamic bankTransferDetails;
  dynamic paypalDetails;
  dynamic westernUnionDetails;
  String balance;
  String deadBalance;
  String fraisInterne;
  dynamic deletedAt;
  DateTime verifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Shop({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.salesManagerName,
    required this.companyRegistration,
    required this.businessLicense,
    required this.phoneNumber,
    required this.emailAddress,
    this.logo,
    this.banner,
    this.bankTransferDetails,
    this.paypalDetails,
    this.westernUnionDetails,
    required this.balance,
    required this.deadBalance,
    required this.fraisInterne,
    this.deletedAt,
    required this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        companyName: json["company_name"] ?? '',
        salesManagerName: json["sales_manager_name"] ?? '',
        companyRegistration: json["company_registration"] ?? '',
        businessLicense: json["business_license"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        emailAddress: json["email_address"] ?? '',
        logo: json["logo"],
        banner: json["banner"],
        bankTransferDetails: json["bank_transfer_details"],
        paypalDetails: json["paypal_details"],
        westernUnionDetails: json["western_union_details"],
        balance: json["balance"] ?? '0.00',
        deadBalance: json["dead_balance"] ?? '0.00',
        fraisInterne: json["frais_interne"] ?? '0.00',
        deletedAt: json["deleted_at"],
        verifiedAt: DateTime.parse(json["verified_at"] ?? DateTime.now().toString()),
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_name": companyName,
        "sales_manager_name": salesManagerName,
        "company_registration": companyRegistration,
        "business_license": businessLicense,
        "phone_number": phoneNumber,
        "email_address": emailAddress,
        "logo": logo,
        "banner": banner,
        "bank_transfer_details": bankTransferDetails,
        "paypal_details": paypalDetails,
        "western_union_details": westernUnionDetails,
        "balance": balance,
        "dead_balance": deadBalance,
        "frais_interne": fraisInterne,
        "deleted_at": deletedAt,
        "verified_at": verifiedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Category {
  int id;
  String name;
  dynamic description;
  String? logo;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        description: json["description"],
        logo: json["logo"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "logo": logo,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ProductMedia {
  int id;
  int productId;
  String mediaUrl;
  String mediaType;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  ProductMedia({
    required this.id,
    required this.productId,
    required this.mediaUrl,
    required this.mediaType,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) => ProductMedia(
        id: json["id"] ?? 0,
        productId: json["product_id"] ?? 0,
        mediaUrl: json["media_url"] ?? '',
        mediaType: json["media_type"] ?? 'image',
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "media_url": mediaUrl,
        "media_type": mediaType,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Review {
  int id;
  int productId;
  int rating;
  String comment;
  User user;
  DateTime createdAt;
  DateTime updatedAt;

  Review({
    required this.id,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"] ?? 0,
        productId: json["product_id"] ?? 0,
        rating: json["rating"] ?? 0,
        comment: json["comment"] ?? '',
        user: User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "rating": rating,
        "comment": comment,
        "user": user.toJson(),
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
  String? country;
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
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.country,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? 0,
        firstname: json["firstname"] ?? '',
        lastname: json["lastname"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        adresse: json["adresse"],
        avatar: json["avatar"],
        role: json["role"] ?? 'CUSTOMER',
        email: json["email"] ?? '',
        emailVerifiedAt:
            DateTime.parse(json["email_verified_at"] ?? DateTime.now().toString()),
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toString()),
        deletedAt: json["deleted_at"],
        country: json["country"],
        status: json["status"] ?? 0,
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

class Links {
  String first;
  String last;
  dynamic prev;
  String next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"] ?? '',
        last: json["last"] ?? '',
        prev: json["prev"],
        next: json["next"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
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

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"] ?? 0,
        from: json["from"] ?? 0,
        lastPage: json["last_page"] ?? 0,
        links: List<Link>.from(
            json["links"]?.map((x) => Link.fromJson(x)) ?? []),
        path: json["path"] ?? '',
        perPage: json["per_page"] ?? 0,
        to: json["to"] ?? 0,
        total: json["total"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"] ?? '',
        active: json["active"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
