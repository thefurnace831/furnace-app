import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';

class AdminViewRoomsScreen extends StatelessWidget {
  const AdminViewRoomsScreen({super.key});
  // Add viewModel later
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Admin Dashboard"),
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
                            subtitle: "Viewing Rooms",
                            logoWidth: 220,
                          ),
                        ]))))));
  }
}
