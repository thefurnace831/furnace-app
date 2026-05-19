import 'package:flutter/material.dart';

// Admin settings edit screen.
class AdminSettingsEditScreen extends StatelessWidget {
  const AdminSettingsEditScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Main page layout.
    return Scaffold(

      // Top app bar.
      appBar: AppBar(
        title: const Text("Edit Settings"),
      ),

      // Main page content.
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            // Page title.
            const Text(
              "Edit Administrator Information",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Name input field.
            const TextField(
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Email input field.
            const TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Phone input field.
            const TextField(
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // Save button placeholder.
            ElevatedButton(
              onPressed: () {

                // Future save settings functionality.
              },

              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}