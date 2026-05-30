import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';
import 'package:furnace_app/widgets/student_activity_card.dart';
import 'package:furnace_app/widgets/student_card.dart';
import 'package:intl/intl.dart';

import '../../../furnace_ui.dart';

class StudentDetailsScreen extends StatefulWidget {
  final StudentDetailsViewmodel viewModel;

  const StudentDetailsScreen({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late final TextEditingController _birthdayController;
  late final TextEditingController _ethnicityController;
  late final TextEditingController _genderController;
  late final TextEditingController _roleController;

  @override
  void initState() {
    super.initState();

    _birthdayController = TextEditingController(text: '');
    _ethnicityController = TextEditingController(text: '');
    _genderController = TextEditingController(text: '');
    _roleController = TextEditingController(text: '');

    widget.viewModel.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onResult);
    _birthdayController.dispose();
    _ethnicityController.dispose();
    _genderController.dispose();
    _roleController.dispose();

    super.dispose();
  }

  void _onResult() {
    final student = widget.viewModel.student;

    if (student == null) {
      return;
    }

    _birthdayController.text = student.birthday;
    _ethnicityController.text = student.ethnicity;
    _genderController.text = student.gender;
    _roleController.text = "Student";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("The Furnace"),
        ),
        body: FurnaceBackground(
            pattern: true,
            child: FurnaceContent(
                maxWidth: 560,
                child: ListenableBuilder(
                  listenable: widget.viewModel.loadStudentById,
                  builder: (context, child) {
                    if (widget.viewModel.loadStudentById.running) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (widget.viewModel.loadStudentById.error) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("There was an error fetching students."),
                          ElevatedButton(
                              onPressed: () {
                                widget.viewModel.loadStudentById
                                    .execute(widget.viewModel.userId);
                              },
                              child: Text("Try Again"))
                        ],
                      );
                    }

                    return child!;
                  },
                  child: _buildStudentContent(widget.viewModel),
                ))));
  }

  Widget _buildStudentContent(StudentDetailsViewmodel viewModel) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.student != null) {
            return FurnacePanel(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudentCard(
                    fullName: viewModel.student!.name,
                    email: viewModel.student!.username,
                    phoneNumber: viewModel.student!.phoneNumber,
                    schoolName: viewModel.student!.schoolName,
                    // No grade field in _User class
                    grade: ""),
                Container(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.analytics),
                    Container(width: 10),
                    Text(
                      "Student Activities",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ],
                ),
                StudentActivityCard(
                  logs: viewModel.recentLogs,
                  sessionsAttended: viewModel.sessionsAttended,
                  lastSessionAttended:
                      viewModel.recentLogs.firstOrNull?.createdAt == null
                          ? "None"
                          : DateFormat('MM/dd/yyyy')
                              .format(viewModel.recentLogs.first.createdAt),
                ),
                Container(height: 20),
                Text(
                  "Student Details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(height: 12),
                TextField(
                    enabled: false,
                    controller: _birthdayController,
                    decoration: const InputDecoration(
                      labelText: "Birthday",
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(),
                    )),
                Container(height: 12),
                // TODO: Make ethnicity, gender, role dropdown options
                TextField(
                    enabled: false,
                    controller: _ethnicityController,
                    decoration: const InputDecoration(
                      labelText: "Ethnicity",
                      prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                    )),
                Container(height: 12),
                TextField(
                    enabled: false,
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      prefixIcon: Icon(Icons.transgender),
                      border: OutlineInputBorder(),
                    )),
                Container(height: 12),
                Text(
                  "Account details",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Container(height: 12),
                TextField(
                    enabled: false,
                    controller: _roleController,
                    decoration: InputDecoration(
                        labelText: "Role",
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              /** no-op **/
                            },
                            icon: Icon(Icons.edit))))
              ],
            ));
          }

          return Text("User not found");
        });
  }
}
