import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/sign_in.dart';

void main() {
  group('SignInPage', () {
    Widget _wrap(Widget child) => MaterialApp(home: child);

    testWidgets('renders logo, headings, email input, and disabled continue',
        (tester) async {
      await tester.pumpWidget(_wrap(const SignInPage()));
      await tester.pump();

      // Logo image
      expect(find.byType(Image), findsOneWidget);

      // Headings
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text("Choose how you'd like to sign in"), findsOneWidget);

      // Email input
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);

      // Continue button disabled
      final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'CONTINUE'));
      expect(button.onPressed, isNull);
    });
  });
}
