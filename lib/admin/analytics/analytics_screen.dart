import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Main analytics page
    return Scaffold(

      // Top app bar
      appBar: AppBar(
        title: const Text("Analytics"),
      ),

      // Main screen body
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Page title
            const Text(
              "Analytics Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Daily attendance button
            ElevatedButton(
              onPressed: () {},

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  "Daily Attendance",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sessions button
            ElevatedButton(
              onPressed: () {},

              child: const Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  "Sessions",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}