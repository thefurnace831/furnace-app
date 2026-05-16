import 'package:flutter/cupertino.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/utils/command.dart';

import '../../api/user.dart';
import '../../utils/result.dart';

class AdminViewStudentsViewmodel extends ChangeNotifier {
  AdminViewStudentsViewmodel({
    required StudentRepository studentRepository,
  }) : _studentRepository = studentRepository {
    loadStudents = Command0(_getStudents)..execute();
    searchController.addListener(_filterStudents);
  }

  final StudentRepository _studentRepository;
  late Command0 loadStudents;

  final searchController = TextEditingController();

  ValueNotifier<List<User>> _allStudents = ValueNotifier([]);

  ValueNotifier<List<User>> get allStudents => _allStudents;

  ValueNotifier<List<User>> _filteredStudents = ValueNotifier([]);

  ValueNotifier<List<User>> get filteredStudents => _filteredStudents;

  @override
  void dispose() {
    searchController.removeListener(_filterStudents);
    searchController.dispose();
    super.dispose();
  }

  Future<Result> _getStudents() async {
    final result = await _studentRepository.getAllStudents();

    switch (result) {
      case Ok<List<User>>():
        _allStudents.value = result.value;
        _filteredStudents.value = List.of(_allStudents.value);
      case Error<List<User>>():
      /** no-op **/
    }
    return result;
  }

  void _filterStudents() {
    final text = searchController.text;
    String query = text.toLowerCase();
    _filteredStudents.value = _allStudents.value
        .where((student) => student.name.toLowerCase().contains(query))
        .toList();
  }

  void clearFilter() {
    searchController.clear();
    _filteredStudents.value = List.of(_allStudents.value);
    notifyListeners();
  }
}
