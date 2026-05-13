import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_home/admin_home_screen_viewmodel.dart';
import 'package:furnace_app/admin/admin_view_students/admin_view_students_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/widgets/dashboard_card.dart';

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
                    FurnaceBrandHeader(
                      title: "Admin Dashboard",
                      subtitle: "Viewing All Users",
                      logoWidth: 220,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
