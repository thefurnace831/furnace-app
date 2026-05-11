import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:furnace_app/widgets/dashboard_card.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("The Furnace"),
        ),
        body:
        FurnaceBackground(
          pattern: true,
          child: FurnaceContent(
              maxWidth: 560,
              child: FurnacePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FurnaceBrandHeader(
                      title: "Admin Dashboard",
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
                                  onClick: () { print("View users clicked"); },
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: DashboardCard(
                                  icon: Icons.qr_code,
                                  description: "view QRs",
                                  height: 163,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(
                          height: 120,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.analytics,
                                  description: "analytics",
                                  height: 163,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: DashboardCard(
                                  icon: Icons.settings,
                                  description: "settings",
                                  height: 163,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

}