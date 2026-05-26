import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/result.dart';
import 'package:collection/collection.dart';

class StudentRepositoryFake extends StudentRepository {
  final List<User> _students = [
    User(
      userId: '1',
      name: 'Test Student',
      username: 'teststudent@email.com',
      email: 'teststudent@email.com',
      phoneNumber: '',
      schoolName: '',
    ),
    User(
        userId: '2',
        name: 'Alex Johnson',
        email: 'alex@email.com',
        username: 'alex@email.com',
        phoneNumber: '',
        schoolName: ''),
    User(
        userId: '3',
        name: 'Maria Lopez',
        email: 'maria@email.com',
        username: 'alex@email.com',
        phoneNumber: '',
        schoolName: ''),
  ];

  bool isSuccessful = true;

  @override
  Future<Result<List<User>>> getAllStudents() async {
    if (isSuccessful) {
      return Result.ok(_students);
    }

    return Result.error(
      Exception('Failed to load students'),
    );
  }

  @override
  Future<Result<User?>> getStudentById(String userId) async {
    if (isSuccessful) {
      User? user = _students.firstWhereOrNull((user) => user.userId == userId);
      return Result.ok(user);
    }

    return Result.error(
      Exception('Failed to load students'),
    );
  }
}
