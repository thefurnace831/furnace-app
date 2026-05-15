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

  List<User> _allStudents = [];
  List<User> get allStudents => _allStudents;

  List<User> _filteredStudents = [];
  List<User> get filteredStudents => _filteredStudents;

  String _searchTerm = "";
  String get searchTerm => _searchTerm;

  @override
  void dispose() {
    searchController.removeListener(_filterStudents);
    searchController.dispose();
    super.dispose();
  }
  
  Future<Result> _getStudents() async {
    try {
      final result = await _studentRepository.getAllStudents();

      switch (result) {
        case Ok<List<User>>():
          _allStudents = result.value;
          _filteredStudents = List.of(_allStudents);
        case Error<List<User>>():
        /** no-op **/
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _filterStudents() {
    final text = searchController.text;
    String query = text.toLowerCase();
    _filteredStudents = _allStudents
        .where((student) => student.name.toLowerCase().contains(query))
        .toList();
    notifyListeners();
  }

  void clearFilter() {
    searchController.clear();
    _filteredStudents = List.of(_allStudents);
    notifyListeners();
  }
}
