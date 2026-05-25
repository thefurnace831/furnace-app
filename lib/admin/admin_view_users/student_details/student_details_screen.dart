import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';
import 'package:furnace_app/api/time_log.dart';
import 'package:furnace_app/widgets/student_activity_card.dart';
import 'package:furnace_app/widgets/student_card.dart';

import '../../../furnace_ui.dart';

class StudentDetailsScreen extends StatelessWidget {
  final StudentDetailsViewmodel viewModel;

  const StudentDetailsScreen({super.key, required this.viewModel});

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
                  listenable: viewModel.loadStudentById,
                  builder: (context, child) {
                    if (viewModel.loadStudentById.running) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.loadStudentById.error) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("There was an error fetching students."),
                          ElevatedButton(
                              onPressed: () {
                                viewModel.loadStudentById
                                    .execute(viewModel.userId);
                              },
                              child: Text("Try Again"))
                        ],
                      );
                    }

                    return child!;
                  },
                  child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) {
                        if (viewModel.student != null) {
                          return FurnacePanel(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StudentCard(
                                  fullName: viewModel.student!.name,
                                  email: viewModel.student!.email,
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              StudentActivityCard(
                                  logs: viewModel.recentLogs,
                                  sessionsAttended: viewModel.sessionsAttended,
                                  lastSessionAttended: viewModel
                                      .recentLogs.first.createdAt
                                      .toString())
                            ],
                          ));
                        }

                        return Text("User not found");
                      }),
                ))));
  }
}
