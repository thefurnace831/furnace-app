import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:furnace_app/login.dart';

void main() {
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
