import 'package:flutter_test/flutter_test.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository_fake.dart';
import 'package:furnace_app/data/repositories/time_log/time_log_repository_fake.dart';

void main () {
  final User expectedStudent = User(
    userId: '2',
    name: 'Alex Johnson',
    email: 'alex@email.com',
    username: 'alex@email.com',
    phoneNumber: '555-0102',
    schoolName: 'Seaside High School',
    birthday: '2006-09-22',
    ethnicity: 'Asian',
    gender: 'Male',
  );

  group("StudentDetailsViewModel test", () {
    test("Student is correctly initialized", () async {
      final viewModel = StudentDetailsViewmodel(
          userId: "2",
          studentRepository: StudentRepositoryFake(),
          timeLogRepository: TimeLogRepositoryFake(),
      );

      await viewModel.loadStudentById.execute("2");
      expect(viewModel.student?.username, expectedStudent.username);
      expect(viewModel.loadStudentById.error, false);
    });

    test("Student is null when id does not exist", () async {
      final viewModel = StudentDetailsViewmodel(
        userId: "4",
        studentRepository: StudentRepositoryFake(),
        timeLogRepository: TimeLogRepositoryFake(),
      );

      await viewModel.loadStudentById.execute("4");

      expect(viewModel.student, null);
      expect(viewModel.recentLogs.isEmpty, true);
      expect(viewModel.sessionsAttended, 0);
    });

    test("Student is null when an error occurs", () async {
      final StudentRepositoryFake studentRepositoryFake = StudentRepositoryFake();
      studentRepositoryFake.isSuccessful = false;
      final viewModel = StudentDetailsViewmodel(
        userId: "2",
        studentRepository: studentRepositoryFake,
        timeLogRepository: TimeLogRepositoryFake(),
      );

      await viewModel.loadStudentById.execute("2");

      expect(viewModel.student, null);
      expect(viewModel.recentLogs.isEmpty, true);
      expect(viewModel.sessionsAttended, 0);
      expect(viewModel.loadStudentById.error, false);
    });
  });
}