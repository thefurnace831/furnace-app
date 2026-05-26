import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// TODO: Add remaining _User fields
class User {
  final String userId;
  final String name;
  final String email;
  final String username;
  final String phoneNumber;
  final String schoolName;

  User({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.schoolName,
  });

  factory User.fromParseObject(ParseObject object) {
    return User(
      userId: object.objectId ?? '',
      name: object.get<String>('fullName') ?? '',
      username: object.get<String>('username') ?? '',
      email: object.get<String>('email') ?? '',
      phoneNumber: object.get<String>('phoneNumber') ?? '',
      schoolName: object.get<String>('schoolName') ?? '',
    );
  }
}
