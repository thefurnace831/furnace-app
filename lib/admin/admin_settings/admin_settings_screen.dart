import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Main admin settings screen.
class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Main page structure.
    return Scaffold(

      // Top app bar.
      appBar: AppBar(
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

                    // Admin display name.
                    const Text(
                      "Katie Lopez",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Admin role text.
                    const Text(
                      "Administrator",

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email information section.
                    const ListTile(
                      leading: Icon(Icons.email),

                      title: Text("Email"),

                      subtitle: Text("admin@furnace.org"),
                    ),

                    const Divider(),

                    // Phone information section.
                    const ListTile(
                      leading: Icon(Icons.phone),

                      title: Text("Phone"),

                      subtitle: Text("(000) 000-0000"),
                    ),

                    const Divider(),

                    // Role information section.
                    const ListTile(
                      leading: Icon(Icons.badge),

                      title: Text("Role"),

                      subtitle: Text("Administrator"),
                    ),

                    const SizedBox(height: 20),

                    // Future edit settings button.
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