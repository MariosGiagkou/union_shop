import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/sign_in.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('SignInPage', () {
    testWidgets('renders all UI elements', (tester) async {
      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Enter your email and password'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'SIGN IN'), findsOneWidget);
    });

    testWidgets('validates email format', (tester) async {
      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: createSignedOutAuthService(),
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Password'),
        '123456',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN IN'),
      );

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('validates required email', (tester) async {
      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: createSignedOutAuthService(),
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN IN'),
      );

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('validates required password', (tester) async {
      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: createSignedOutAuthService(),
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN IN'),
      );

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('signs in successfully with valid credentials', (tester) async {
      final authService = createSignedOutAuthService();

      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: authService,
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN IN'),
      );

      expect(authService.isSignedIn, true);
      expect(authService.userEmail, 'test@example.com');
    });

    testWidgets('shows error with invalid credentials', (tester) async {
      final authService = createSignedOutAuthService();

      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: authService,
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Email'),
        'wrong@example.com',
      );
      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Password'),
        'wrongpassword',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN IN'),
      );

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(authService.isSignedIn, false);
    });

    testWidgets('toggles to sign up mode', (tester) async {
      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: createSignedOutAuthService(),
      );

      expect(find.text('Sign In'), findsOneWidget);

      await tapAndSettle(
        tester,
        find.text("Don't have an account? Sign Up"),
      );

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'SIGN UP'), findsOneWidget);
    });

    testWidgets('signs up successfully', (tester) async {
      final authService = createSignedOutAuthService();

      await pumpWithProviders(
        tester,
        const SignInPage(),
        authService: authService,
      );

      await tapAndSettle(
        tester,
        find.text("Don't have an account? Sign Up"),
      );

      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Email'),
        'newuser@example.com',
      );
      await enterTextAndSettle(
        tester,
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      await tapAndSettle(
        tester,
        find.widgetWithText(ElevatedButton, 'SIGN UP'),
      );

      expect(authService.isSignedIn, true);
      expect(authService.userEmail, 'newuser@example.com');
    });
  });
}
