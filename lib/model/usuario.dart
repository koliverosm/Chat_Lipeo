class User {
  final String iduser;
  final String fullname;
  final String password;
  final String phone;
  final DateTime timestamp;
  User(
      {required this.iduser,
      required this.fullname,
      required this.password,
      required this.phone,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "iduser": iduser,
      "fullname": fullname,
      "password": password,
      "phone": phone,
      "timestamp": timestamp
    };
  }
}
