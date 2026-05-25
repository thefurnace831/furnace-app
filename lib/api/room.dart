import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Room {
  String roomId;
  String roomName;
  String qrRoomValue;
  String qrCheckoutValue;

  Room(
      {required this.roomId,
      required this.roomName,
      required this.qrRoomValue,
      required this.qrCheckoutValue});

// Switch from json to parseobject
  factory Room.fromParseObject(ParseObject object) {
    return Room(
        roomId: object.objectId ?? '',
        roomName: object.get<String>('roomName') ?? '',
        qrRoomValue: object.get<String>('qrRoomValue') ?? '',
        qrCheckoutValue: object.get<String>('qrCheckoutValue') ?? '');
  }
}
