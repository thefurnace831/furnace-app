import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_view_users/view_users_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/widgets/dashboard_card.dart';
import 'package:go_router/go_router.dart';

class ViewUsersScreen extends StatelessWidget {
  final ViewUsersViewmodel viewModel;

  const ViewUsersScreen({super.key, required this.viewModel});

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
              child: FurnacePanel(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FurnaceBrandHeader(
                    title: "Admin Dashboard",
                    subtitle: "Users",
                    logoWidth: 220,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: DashboardCard(
                        icon: Icons.people_sharp,
                        description: "View Students",
                        height: 163,
                        onClick: () {
                          context.push('/admin-view-students');
                        },
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: DashboardCard(
                        icon: Icons.admin_panel_settings_sharp,
                        description: "View Admins",
                        height: 163,
                        onClick: () {
                          context.push("/admin-view-admins");
                        },
                      )),
                    ],
                  )
                ],
              )))),
    );
  }
}
