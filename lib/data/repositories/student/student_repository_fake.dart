import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/result.dart';

class StudentRepositoryFake extends StudentRepository {
  bool isSuccessful = true;

  @override
  Future<Result<List<User>>> getAllStudents() async {
    final List<User> students = [
      User(
        userId: '1',
        name: 'Test Student',
        username: 'teststudent@email.com',
        email: 'teststudent@email.com',
      ),
      User(
        userId: '2',
        name: 'Alex Johnson',
        email: 'alex@email.com',
        username: 'alex@email.com'
      ),
      User(
        userId: '3',
        name: 'Maria Lopez',
        email: 'maria@email.com',
        username: 'alex@email.com'
      ),
    ];

    if (isSuccessful) {
      return Result.ok(students);
    }

    return Result.error(
      Exception('Failed to load students'),
    );
  }

}