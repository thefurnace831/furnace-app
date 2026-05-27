import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:go_router/go_router.dart';
import 'admin_settings_viewmodel.dart';

// Admin settings edit screen.
// This screen is currently frontend-only and uses placeholder fields.
class AdminSettingsEditScreen extends StatelessWidget {

  final AdminSettingsViewmodel viewModel;

  const AdminSettingsEditScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Top app bar.
      appBar: AppBar(
        title: const Text("Admin Account"),
      ),

      // Furnace background keeps this screen visually consistent
      // with the other admin dashboard screens.
      body: FurnaceBackground(
        pattern: true,

        child: FurnaceContent(
          maxWidth: 560,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [

                // Furnace logo/header section.
                const FurnaceBrandHeader(
                  title: "Admin Dashboard",
                  subtitle: "Account Settings",
                  logoWidth: 220,
                ),

                const SizedBox(height: 24),

                // Main edit form panel.
                FurnacePanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [

                      // Dark admin profile card.
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1B18),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Row(
                          children: [

                            // Profile icon box.
                            Container(
                              width: 42,
                              height: 42,

                              decoration: BoxDecoration(
                                color: const Color(0xFF3A2B12),
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: const Icon(
                                Icons.person_outline,
                                color: Color(0xFFE0A12B),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Admin name/email.
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "Katie Lopez",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "email@email.com",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Editing status chip.
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF8BC06F),
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),

                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xFF8BC06F),
                                    size: 14,
                                  ),

                                  SizedBox(width: 4),

                                  Text(
                                    "Editing",
                                    style: TextStyle(
                                      color: Color(0xFF8BC06F),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Section title.
                      const Text(
                        "Administrator details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Name input field.
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "First Name & Last Name",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Email input field.
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Phone input field.
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Role input field.
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Role",
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Save button aligned like the mockup.
                      Align(
                        alignment: Alignment.centerRight,

                        child: ElevatedButton.icon(
                          onPressed: () {

                            // Shows confirmation message.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Admin settings saved successfully.",
                                ),
                              ),
                            );

                            // Returns user back to previous screen.
                            context.pop();
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}