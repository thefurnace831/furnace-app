import 'package:flutter/cupertino.dart';
import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository.dart';
import 'package:furnace_app/data/repositories/time_log/time_log_repository.dart';
import 'package:furnace_app/utils/command.dart';
import 'package:furnace_app/utils/result.dart';

class StudentDetailsViewmodel extends ChangeNotifier {
  final String userId;

  StudentDetailsViewmodel(
      {required this.userId,
      required StudentRepository studentRepository,
      required TimeLogRepository timeLogRepository})
      : _timeLogRepository = timeLogRepository,
        _studentRepository = studentRepository {
    loadStudentById = Command1<User?, String>(_getStudentById)..execute(userId);
  }

  final StudentRepository _studentRepository;
  final TimeLogRepository _timeLogRepository;
  late Command1<User?, String> loadStudentById;

  User? _student;

  User? get student => _student;

  List<TimeLog> _recentLogs = [];

  List<TimeLog> get recentLogs => _recentLogs;

  int _sessionsAttended = 0;
  int get sessionsAttended => _sessionsAttended;

  Future<Result<List<TimeLog>>> _getStudentLogs(String userEmail) async {
    final result =
        await _timeLogRepository.getStudentsSessionsAttended(userEmail);

    switch (result) {
      case Ok<List<TimeLog>>(value: final logs):
        if (logs.length <= 5) {
          _recentLogs = logs;
        } else {
          for (int i = 0; i < 5; i++) {
            _recentLogs.add(logs[i]);
          }
        }
        _sessionsAttended = logs.length;
      case Error<List<TimeLog>>():
        _recentLogs = [];
    }
    return result;
  }

  Future<Result<User?>> _getStudentById(String userId) async {
    try {
      final result = await _studentRepository.getStudentById(userId);

      switch (result) {
        case Ok<User?>():
          _student = result.value;
          await _getStudentLogs(_student!.email);
        case Error<User?>():
          /** no-op **/
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
