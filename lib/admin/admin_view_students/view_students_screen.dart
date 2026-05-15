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
                      int totalStudents = viewModel.filteredStudents.length;
                      return FurnaceBrandHeader(
                        title: "Admin Dashboard",
                        subtitle: "Viewing $totalStudents Students",
                        logoWidth: 220,
                      );
                    }),
                    SizedBox(height: 10),
                    ListenableBuilder(listenable: viewModel, builder: (context, _) {
                      return TextField(
                          controller: viewModel.searchController,
                          decoration: InputDecoration(
                              hintText: 'Search students',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: viewModel.searchController.text.isEmpty
                                  ? null
                                  : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: viewModel.clearFilter
                              )
                          )
                      );
                    }),
                    ListenableBuilder(
                        listenable: viewModel,
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

                          return SizedBox(
                            height: 400,
                            child: viewModel.filteredStudents.isEmpty ? const Center(
                              child: Text('No students found.'),
                            ) : ListView.separated(
                              itemCount: viewModel.filteredStudents.length,
                              separatorBuilder: (context, index) {
                                return const Divider(height: 1);
                              },
                              itemBuilder: (context, index) {
                                final student = viewModel.filteredStudents[index];
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(student.name),
                                  onTap: () {
                                    debugPrint(
                                      'Selected student: ${student.name}',
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        })
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
