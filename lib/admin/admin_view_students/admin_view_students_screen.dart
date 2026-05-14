import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_view_students/admin_view_students_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';

class AdminViewStudentsScreen extends StatelessWidget {
  const AdminViewStudentsScreen({super.key, required this.viewModel});

  final AdminViewStudentsViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("The Furnace"),
        ),
        body: FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
              maxWidth: 560,
              child: FurnacePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListenableBuilder(listenable: viewModel, builder: (context, _) {
                      int totalStudents = viewModel.students.length;
                      return FurnaceBrandHeader(
                        title: "Admin Dashboard",
                        subtitle: "Viewing All $totalStudents Students",
                        logoWidth: 220,
                      );
                    }),

                    ListenableBuilder(
                        listenable: viewModel.loadStudents,
                        builder: (context, child) {
                      if (viewModel.loadStudents.running) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (viewModel.loadStudents.error) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("There was an error fetching students."),
                            ElevatedButton(
                                onPressed: viewModel.loadStudents.execute,
                                child: Text("Try Again")
                            )
                          ],
                        );
                      }
                      
                      return Text(viewModel.students.toString());
                    })
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
