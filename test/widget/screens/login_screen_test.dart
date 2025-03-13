import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:aptora/features/auth/screens/login_screen.dart';

void main() {
  testWidgets('Login screen shows error on invalid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final loginButton = find.text('Login');
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
  });
} 