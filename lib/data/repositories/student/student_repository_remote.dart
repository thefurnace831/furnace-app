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
        // If no users are returned, Parse can return null instead of an empty list.
        final List<ParseObject> studentsObject =
        (response.results ?? []).cast<ParseObject>();
        return Result.ok(studentsObject.map(User.fromParseObject).toList());
      }
      return Result.error(
        Exception(response.error?.message ?? 'Failed to load students'),
      );
  }
}
