import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_view_users/student_details/student_details_viewmodel.dart';

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
                        return Text(viewModel.student!.name);
                      }),
                ))));
  }
}
