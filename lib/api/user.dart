import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// TODO: Add remaining _User fields
class User {
  final String userId;
  final String name;
  final String username;

  User({
    required this.userId,
    required this.name,
    required this.username,
  });

  factory User.fromParseObject(ParseObject object) {
    return User(
      userId: object.objectId ?? '',
      name: object.get<String>('fullName') ?? '',
      username: object.get<String>('username') ?? '',
    );
  }
}