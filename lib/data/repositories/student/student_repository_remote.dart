import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentRepositoryRemote extends StudentRepository {
  @override
  Future<Result<List<User>>> getAllStudents() async {
      final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject('_User'));
      final response = await query.query();

      if (response.success) {
        List<ParseObject> studentsObject = response.results as List<ParseObject>;
        return Result.ok(studentsObject.map(User.fromParseObject).toList());
      }
      return Result.error(
        Exception(response.error?.message ?? 'Failed to load students'),
      );
  }
}

/*
Future<List<User>> getAllStudents() async {
  final query = QueryBuilder<ParseObject>(
    ParseObject('_User'),
  );

  final response = await query.query();

  print('success: ${response.success}');
  print('error: ${response.error?.message}');
  print('count: ${response.count}');
  print('results: ${response.results}');

  if (!response.success) {
    throw Exception(response.error?.message ?? 'Failed to load students');
  }

  final results = response.results;

  if (results == null) {
    return [];
  }

  return results
      .cast<ParseObject>()
      .map(User.fromParseObject)
      .toList();
}
 */