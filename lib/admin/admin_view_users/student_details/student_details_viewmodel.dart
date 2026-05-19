import 'package:flutter/cupertino.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/command.dart';
import 'package:furnace_app/utils/result.dart';

class StudentDetailsViewmodel extends ChangeNotifier {
  final String userId;

  StudentDetailsViewmodel(
      {required this.userId, required StudentRepository studentRepository})
      : _studentRepository = studentRepository {
    print("Getting $userId");
    loadStudentById = Command1<User?, String>(_getStudentById)..execute(userId);
  }

  final StudentRepository _studentRepository;
  late Command1<User?, String> loadStudentById;

  User? _student = null;
  User? get student => _student;

  Future<Result<User?>> _getStudentById(String userId) async {
    try {
      final result = await _studentRepository.getStudentById(userId);

      switch (result) {
        case Ok<User?>():
          _student = result.value;
          print(_student?.name);
        case Error<User?>():
          /** no-op **/
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
