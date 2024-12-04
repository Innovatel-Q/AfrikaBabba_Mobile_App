import 'package:get/get.dart';

class Conversation {
  final int id;
  final User userOne;
  final User userTwo;
  final RxList<Message> messages;

  Conversation({
    required this.id,
    required this.userOne,
    required this.userTwo,
    List<Message>? messages,
  }) : messages = (messages ?? []).obs;

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      userOne: User.fromJson(json['user_one']),
      userTwo: User.fromJson(json['user_two']),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((m) => Message.fromJson(m))
          .toList()
          .obs ?? <Message>[].obs,
    );
  }
}

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String? address;
  final String? avatar;
  final String role;
  final String email;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? country;
  final int status;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    this.address,
    this.avatar,
    required this.role,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.country,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phoneNumber: json['phone_number'],
      address: json['adresse'],
      avatar: json['avatar'],
      role: json['role'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      country: json['country'],
      status: json['status'],
    );
  }
}

class Message {
  final int id;
  final int userId;
  final int conversationId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.userId,
    required this.conversationId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['user_id'],
      conversationId: json['conversation_id'],
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
