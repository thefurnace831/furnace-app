import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/utils/result.dart';

abstract class TimeLogRepository {
  Future<Result<int>> getStudentsTotalSessionsAttended(String userEmail);
  Future<Result<List<TimeLog>>> getStudentsSessionsAttended(String userEmail);
}