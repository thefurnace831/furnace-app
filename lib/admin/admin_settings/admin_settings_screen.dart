import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'admin_settings_viewmodel.dart';

// Main admin settings screen.
class AdminSettingsScreen extends StatelessWidget {
  final AdminSettingsViewmodel viewModel;

  const AdminSettingsScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    // Main page structure.
    return Scaffold(

      // Top app bar.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed('adminHome');
          },
        ),

        title: const Text("Admin Settings"),
      ),

      // Main page content padding.
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          // Align content to the left.
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            // Main page title.
            const Text(
              "Administrator Account",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle/description text.
            const Text(
              "Manage administrator information and account settings.",

              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            // Main settings information card.
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(

                  // Align card content to the left.
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Admin profile icon/avatar.
                    const CircleAvatar(
                      radius: 32,

                      child: Icon(
                        Icons.person,
                        size: 32,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Admin display name from ViewModel.
                    Text(
                      viewModel.adminName,

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Admin role text from ViewModel.
                    Text(
                      viewModel.adminRole,

                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email information section from ViewModel.
                    ListTile(
                      leading: const Icon(Icons.email),

                      title: const Text("Email"),

                      subtitle: Text(viewModel.adminEmail),
                    ),

                    const Divider(),

                    // Phone information section from ViewModel.
                    ListTile(
                      leading: const Icon(Icons.phone),

                      title: const Text("Phone"),

                      subtitle: Text(viewModel.adminPhone),
                    ),

                    const Divider(),

                    // Role information section from ViewModel.
                    ListTile(
                      leading: const Icon(Icons.badge),

                      title: const Text("Role"),

                      subtitle: Text(viewModel.adminRole),
                    ),

                    const SizedBox(height: 20),

                    // Opens edit settings screen.
                    ElevatedButton(
                      onPressed: () {

                        // Opens the edit settings screen.
                        context.goNamed('adminSettingsEdit');
                      },

                      child: const Text("Edit Settings"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}