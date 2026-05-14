import 'package:flutter/cupertino.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/command.dart';

import '../../api/user.dart';
import '../../utils/result.dart';

class AdminViewStudentsViewmodel extends ChangeNotifier {

  AdminViewStudentsViewmodel({
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository {
    loadStudents = Command0(_getStudents)
      ..execute();
  }

  final StudentRepository _studentRepository;

  List<User> _students = [];
  List<User> get students => _students;

  late Command0 loadStudents;

  Future<Result> _getStudents() async {
    try {
      final result = await _studentRepository.getAllStudents();

      switch (result) {
        case Ok<List<User>>():
          _students = result.value;
        case Error<List<User>>():
          print("error");
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}