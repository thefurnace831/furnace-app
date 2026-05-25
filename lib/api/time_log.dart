import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TimeLog {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String fullName;
  final String email;
  final String room;
  final String totalTime;

  final DateTime? checkInTime;
  final DateTime? checkOutTime;

  const TimeLog({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
    required this.email,
    required this.room,
    required this.totalTime,
    this.checkInTime,
    this.checkOutTime,
  });

  factory TimeLog.fromParseObject(ParseObject object) {
    return TimeLog(
      id: object.objectId ?? '',
      createdAt: object.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: object.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      fullName: object.get<String>('fullName') ?? '',
      email: object.get<String>('Email') ?? '',
      room: object.get<String>('Room') ?? '',
      totalTime: object.get<String>('TotalTime') ?? '',
      checkInTime: object.get<DateTime>('CheckInTime'),
      checkOutTime: object.get<DateTime>('CheckOutTime'),
    );
  }
}