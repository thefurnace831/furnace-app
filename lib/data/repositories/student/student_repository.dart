import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/utils/result.dart';

abstract class StudentRepository {
  Future<Result<List<User>>> getAllStudents();
}