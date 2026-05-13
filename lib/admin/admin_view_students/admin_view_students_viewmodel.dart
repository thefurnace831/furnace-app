import 'package:flutter/cupertino.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';

import '../../api/user.dart';
import '../../utils/result.dart';
class AdminViewStudentsViewmodel extends ChangeNotifier {

  AdminViewStudentsViewmodel({
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository {
    getStudents();
  }

  final StudentRepository _studentRepository;

  final List<User> _students = [];
  List<User> get students => _students;

  Future<void> getStudents() async {
    final result = await _studentRepository.getAllStudents();
    switch (result) {
      case Ok<List<User>>():
        final students = result.value;

        for (final student in students) {
          print(student.username);
        }

      case Error<List<User>>():
        print(result.error);
    }
  }

}