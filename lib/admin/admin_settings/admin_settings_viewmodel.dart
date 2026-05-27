import 'package:flutter/material.dart';

// ViewModel for the Admin Settings screen.
// Handles administrator account information/state.
class AdminSettingsViewmodel extends ChangeNotifier {

  // Placeholder administrator information.
  String adminName = "Katie Lopez";

  String adminEmail = "admin@furnace.org";

  String adminPhone = "(000) 000-0000";

  String adminRole = "Administrator";

  // Updates administrator information.
  void updateAdminInfo({
    required String name,
    required String email,
    required String phone,
    required String role,
  }) {

    adminName = name;
    adminEmail = email;
    adminPhone = phone;
    adminRole = role;

    // Refreshes listening widgets/screens.
    notifyListeners();
  }
}