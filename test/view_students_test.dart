import 'package:flutter_test/flutter_test.dart';
import 'package:furnace_app/admin/admin_view_users/view_students/admin_view_students_viewmodel.dart';
import 'package:furnace_app/api/user.dart';
import 'package:furnace_app/data/repositories/student/student_repository_fake.dart';

void main() {
  final List<User> expectedStudents = [
    User(
      userId: '1',
      name: 'Test Student',
      username: 'teststudent@email.com',
      email: 'teststudent@email.com',
      phoneNumber: '555-0101',
      schoolName: 'Monterey High School',
      birthday: '2007-04-15',
      ethnicity: 'Prefer not to say',
      gender: 'Prefer not to say',
    ),
    User(
      userId: '2',
      name: 'Alex Johnson',
      email: 'alex@email.com',
      username: 'alex@email.com',
      phoneNumber: '555-0102',
      schoolName: 'Seaside High School',
      birthday: '2006-09-22',
      ethnicity: 'Asian',
      gender: 'Male',
    ),
    User(
      userId: '3',
      name: 'Maria Lopez',
      email: 'maria@email.com',
      username: 'maria@email.com',
      phoneNumber: '555-0103',
      schoolName: 'Salinas High School',
      birthday: '2007-01-08',
      ethnicity: 'Hispanic or Latino',
      gender: 'Female',
    ),
  ];

  group('AdminViewStudentViewModel test', () {
    test("Students list is correctly initialized when loading students", () async {
      final viewModel = AdminViewStudentsViewmodel(
          studentRepository: StudentRepositoryFake());
      await viewModel.loadStudents.execute();
      expect(viewModel.allStudents.isNotEmpty, true);
      for (var i = 0; i < expectedStudents.length; i++) {
        final actual = viewModel.allStudents[i];
        final expected = expectedStudents[i];

        expect(actual.userId, expected.userId);
        expect(actual.name, expected.name);
        expect(actual.username, expected.username);
        expect(actual.email, expected.email);
        expect(actual.phoneNumber, expected.phoneNumber);
        expect(actual.schoolName, expected.schoolName);
        expect(actual.birthday, expected.birthday);
        expect(actual.ethnicity, expected.ethnicity);
        expect(actual.gender, expected.gender);
      }
    });

    test('Empty search shows all students', () async {
      final viewModel = AdminViewStudentsViewmodel(
        studentRepository: StudentRepositoryFake(),
      );

      await viewModel.loadStudents.execute();

      viewModel.searchController.text = '';

      expect(viewModel.filteredStudents.length, viewModel.allStudents.length);

    });

    test('Search field correctly filters students', () async {
      final viewModel = AdminViewStudentsViewmodel(
        studentRepository: StudentRepositoryFake(),
      );

      await viewModel.loadStudents.execute();

      viewModel.searchController.text = 'alex';

      expect(viewModel.filteredStudents.length, 1);
      expect(viewModel.filteredStudents.first.name, 'Alex Johnson');

    });

    test('Searching is not case sensitive', () async {
      final viewModel = AdminViewStudentsViewmodel(
        studentRepository: StudentRepositoryFake(),
      );

      await viewModel.loadStudents.execute();

      viewModel.searchController.text = 'ALEX';

      expect(viewModel.filteredStudents.length, 1);
      expect(viewModel.filteredStudents.first.name, 'Alex Johnson');

    });
  });
}
