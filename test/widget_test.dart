import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:furnace_app/login.dart';
import 'package:furnace_app/main.dart';

void main() {
  testWidgets('shows logged-out entry actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false, isAdmin: false));

    expect(find.text('Teen Center Check-In'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('starts on dashboard when logged in',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: true, isAdmin: false));

    expect(find.text('Check-In Dashboard'), findsOneWidget);
    expect(find.text('QR check in'), findsOneWidget);
  });

  testWidgets('opens password reset screen from login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsWidgets);
    expect(find.text('Send reset email'), findsOneWidget);
  });
}
