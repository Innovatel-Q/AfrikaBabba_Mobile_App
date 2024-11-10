class User {
  final int id;
  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String? address;
  final String email;
  final String password;
  // ignore: non_constant_identifier_names
  final String? avatar_url;
  final String passwordConfirmation;
  final String role;
  final String country;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    this.address,
    required this.email,
    required this.password,
    required this.avatar_url,
    required this.passwordConfirmation,
    required this.role,
    required this.country,
  });


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      email: map['email'] ?? '',
      address: map['address'],
      password: map['password'] ?? '',
      avatar_url: map['avatar_url'] ?? '',
      passwordConfirmation: map['password_confirmation'] ?? '',
      role: map['role'] ?? '',
      country: map['country'] ?? '',
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'avatar_url': avatar_url,
      'lastname': lastname,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'address': address,
      'password_confirmation': passwordConfirmation,
      'role': role,
      'country': country,
    };
  }
}
