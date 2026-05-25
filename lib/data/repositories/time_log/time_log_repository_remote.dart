import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/data/repositories/time_log/time_log_repository.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TimeLogRepositoryRemote extends TimeLogRepository {
  static const String _className = 'TimeLog';

  @override
  Future<Result<List<TimeLog>>> getStudentsSessionsAttended(String userEmail) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject(_className))
        ..whereEqualTo("Email", userEmail)
        ..orderByDescending('CheckInTime');

      final response = await query.query();

      if (!response.success) {
        return Result.error(
          Exception(response.error?.message ?? 'Failed to fetch sessions.'),
        );
      }

      final logs = (response.results ?? [])
          .whereType<ParseObject>()
          .map(TimeLog.fromParseObject)
          .toList();

      return Result.ok(logs);
    } catch (error) {
      return Result.error(Exception(error.toString()));
    }
  }
}