import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class User {
  final String userId;
  final String name;
  final String email;

  User({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userId: responseData['id']?.toString() ?? '',
      name: responseData['name'] ?? '',
      email: responseData['email'] ?? '',
    );
  }

  factory User.fromParseObject(ParseObject object) {
    return User(
      userId: object.objectId ?? '',
      name: object.get<String>('fullName') ??
          object.get<String>('username') ??
          '',
      email: object.get<String>('email') ?? '',
    );
  }
}