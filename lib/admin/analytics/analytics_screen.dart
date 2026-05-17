import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Analytics"),
      ),

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

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              "Track attendance and session activity",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            // Daily attendance analytics card
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.groups,
                      size: 40,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Daily Attendance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "View student attendance metrics and participation.",
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {},

                      child: const Text("View Attendance"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Session analytics card
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Icon(
                      Icons.analytics,
                      size: 40,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Session Analytics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Review active sessions and engagement trends.",
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {},

                      child: const Text("View Sessions"),
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