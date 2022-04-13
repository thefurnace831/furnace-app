class User {
  int userId;
  String name;
  String email;

  User({required this.userId, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email']);
  }
}
