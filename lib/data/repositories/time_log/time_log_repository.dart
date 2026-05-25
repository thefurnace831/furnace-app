import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/utils/result.dart';

abstract class TimeLogRepository {
  Future<Result<List<TimeLog>>> getStudentsSessionsAttended(String userEmail);
}