import 'package:flutter_test/flutter_test.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository_fake.dart';
import 'package:furnace_app/data/repositories/time_log/time_log_repository_fake.dart';

void main () {
  final User expectedStudent = User(
      userId: '1',
      name: 'Test Student',
      username: 'teststudent@email.com',
      email: 'teststudent@email.com',
      phoneNumber: '555-0101',
      schoolName: 'Monterey High School',
      birthday: '2007-04-15',
      ethnicity: 'Prefer not to say',
      gender: 'Prefer not to say',
    );

  group("StudentDetailsViewModel test", () {
    test("Student is correctly initialized", () async {
      final viewModel = StudentDetailsViewmodel(
          userId: "1",
          studentRepository: StudentRepositoryFake(),
          timeLogRepository: TimeLogRepositoryFake(),
      );

      await viewModel.loadStudentById.execute("1");
      expect(viewModel.student?.username, expectedStudent.username);
    });

    test("Student is null when id does not exist", () async {
      final viewModel = StudentDetailsViewmodel(
        userId: "4",
        studentRepository: StudentRepositoryFake(),
        timeLogRepository: TimeLogRepositoryFake(),
      );

      await viewModel.loadStudentById.execute("4");
      expect(viewModel.student, null);
    });
  });
}