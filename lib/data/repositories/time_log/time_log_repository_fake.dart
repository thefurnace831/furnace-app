import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/data/repositories/time_log/time_log_repository.dart';
import 'package:furnace_app/utils/result.dart';

class TimeLogRepositoryFake extends TimeLogRepository {
  final List<TimeLog> timeLogs = [
    TimeLog(
      id: '1',
      createdAt: DateTime(2026, 5, 25, 9, 0),
      updatedAt: DateTime(2026, 5, 25, 11, 30),
      fullName: 'Alex Johnson',
      email: 'alex.johnson@example.com',
      room: 'Library 101',
      totalTime: '2h 30m',
      checkInTime: DateTime(2026, 5, 25, 9, 0),
      checkOutTime: DateTime(2026, 5, 25, 11, 30),
    ),
    TimeLog(
      id: '2',
      createdAt: DateTime(2026, 5, 25, 10, 15),
      updatedAt: DateTime(2026, 5, 25, 12, 0),
      fullName: 'Maria Garcia',
      email: 'maria.garcia@example.com',
      room: 'Study Room B',
      totalTime: '1h 45m',
      checkInTime: DateTime(2026, 5, 25, 10, 15),
      checkOutTime: DateTime(2026, 5, 25, 12, 0),
    ),
    TimeLog(
      id: '3',
      createdAt: DateTime(2026, 5, 25, 13, 0),
      updatedAt: DateTime(2026, 5, 25, 13, 0),
      fullName: 'Jordan Smith',
      email: 'jordan.smith@example.com',
      room: 'Computer Lab',
      totalTime: 'In progress',
      checkInTime: DateTime(2026, 5, 25, 13, 0),
      checkOutTime: null,
    ),
  ];
  @override
  Future<Result<List<TimeLog>>> getStudentsSessionsAttended(String userEmail) async {
    return Result.ok(timeLogs);
  }

}