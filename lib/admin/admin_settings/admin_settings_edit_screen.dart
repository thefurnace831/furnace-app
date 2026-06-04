import 'package:flutter/material.dart';
import 'package:furnace_app/furnace_ui.dart';
import 'package:go_router/go_router.dart';
import 'admin_settings_viewmodel.dart';

// Admin settings edit screen.
class AdminSettingsEditScreen extends StatefulWidget {
  final AdminSettingsViewmodel viewModel;

  const AdminSettingsEditScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<AdminSettingsEditScreen> createState() =>
      _AdminSettingsEditScreenState();
}

class _AdminSettingsEditScreenState extends State<AdminSettingsEditScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController roleController;

  @override
  void initState() {
    super.initState();

    // Prefills form fields from ViewModel.
    nameController = TextEditingController(text: widget.viewModel.adminName);

    emailController = TextEditingController(text: widget.viewModel.adminEmail);

    phoneController = TextEditingController(text: widget.viewModel.adminPhone);

    roleController = TextEditingController(text: widget.viewModel.adminRole);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();

    super.dispose();
  }

  // Validates all form fields before saving.
  bool _validateFields() {
    final hasEmptyField =
        nameController.text.trim().isEmpty ||
            emailController.text.trim().isEmpty ||
            phoneController.text.trim().isEmpty ||
            roleController.text.trim().isEmpty;

    if (hasEmptyField) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please complete all fields before saving.",
          ),
        ),
      );

      return false;
    }

    final hasValidEmail =
        emailController.text.trim().contains("@") &&
            emailController.text.trim().contains(".");

    if (!hasValidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid email address.",
          ),
        ),
      );

      return false;
    }

    final phoneDigits =
    phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (phoneDigits.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid phone number.",
          ),
        ),
      );

      return false;
    }

    if (roleController.text.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid role.",
          ),
        ),
      );

      return false;
    }

    return true;
  }

  // Resets form fields back to ViewModel values.
  void _resetFields() {
    nameController.text = widget.viewModel.adminName;
    emailController.text = widget.viewModel.adminEmail;
    phoneController.text = widget.viewModel.adminPhone;
    roleController.text = widget.viewModel.adminRole;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Changes have been reset.",
        ),
      ),
    );
  }

  // Saves updated form values into the ViewModel.
  void _saveFields() {
    if (!_validateFields()) {
      return;
    }

    widget.viewModel.updateAdminInfo(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      role: roleController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Admin settings saved successfully.",
        ),
      ),
    );

    context.goNamed('adminSettings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed('adminSettings');
          },
        ),

        title: const Text("Admin Account"),
      ),
      body: FurnaceBackground(
        pattern: true,
        child: FurnaceContent(
          maxWidth: 560,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FurnaceBrandHeader(
                  title: "Admin Dashboard",
                  subtitle: "Account Settings",
                  logoWidth: 220,
                ),
                const SizedBox(height: 24),
                FurnacePanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1B18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.viewModel.adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.viewModel.adminEmail,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF8BC06F),
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
                      const Text(
                        "Administrator details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "First Name & Last Name",
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: roleController,
                        decoration: const InputDecoration(
                          labelText: "Role",
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Save button updates the ViewModel after validation passes.
                            ElevatedButton.icon(
                              onPressed: _saveFields,
                              icon: const Icon(Icons.check),
                              label: const Text("Save"),
                            ),
                            const SizedBox(height: 12),
                            // Reset button restores the form back to the current ViewModel values.
                            OutlinedButton.icon(
                              onPressed: _resetFields,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reset"),
                            ),const SizedBox(height: 12),

                            OutlinedButton.icon(
                              onPressed: () {
                                context.goNamed('adminSettings');
                              },

                              icon: const Icon(Icons.close),
                              label: const Text("Cancel"),
                            ),
                          ],
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