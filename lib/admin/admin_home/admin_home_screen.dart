import 'package:flutter/material.dart';
import 'package:furnace_app/admin/admin_home/admin_home_screen_viewmodel.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/widgets/dashboard_card.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key, required this.viewModel});

  final AdminHomeScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
                      title: viewModel.title,
                      subtitle: "",
                      logoWidth: 220,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.person,
                                  description: "view users",
                                  height: 163,
                                  onClick: () {
                                    context.push('/admin-view-users');
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.qr_code,
                                  description: "view QRs",
                                  height: 163,
                                  onClick: () {
                                    context.push('/admin-view-rooms');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.analytics,
                                  description: "analytics",
                                  height: 163,

                                  // Opens the Analytics screen.
                                  onClick: () {
                                    context.pushNamed('adminAnalytics');
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.settings,
                                  description: "settings",
                                  height: 163,

                                  // Opens the Admin Settings screen.
                                  onClick: () {
                                    context.pushNamed('adminSettings');
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
