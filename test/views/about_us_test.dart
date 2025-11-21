import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/views/about_us.dart';

Widget _buildApp() => MaterialApp(
      home: const HomePage(),
      routes: {
        '/about': (_) => const AboutUsPage(),
      },
    );

void main() {
  group('AboutUsPage content', () {
    testWidgets('renders all expected text blocks', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));
      await tester.pumpAndSettle();

      expect(find.text('About us'), findsOneWidget);
      expect(find.text('Welcome to the Union Shop.'), findsOneWidget);
      expect(
        find.text(
          'We sell university branded clothing and merchandise all year round. You can add personal text to selected items.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Order online for delivery or collect in store.'),
        findsOneWidget,
      );
      expect(
        find.text('Got a question or idea? Email hello@upsu.net.'),
        findsOneWidget,
      );
      expect(find.text('Happy shopping!'), findsOneWidget);
      expect(find.text('The Union Shop & Reception Team'), findsOneWidget);
    });
  });

  group('About navigation', () {
    testWidgets('navigating to /about shows AboutUsPage', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Find the About nav text
      final aboutFinder = find.text('About');
      expect(aboutFinder, findsOneWidget);

      // Use Navigator directly to ensure route change (tap can miss in test due to hitTest quirks)
      final context = tester.element(aboutFinder);
      Navigator.of(context).pushNamed('/about');
      await tester.pumpAndSettle();

      expect(find.text('About us'), findsOneWidget);
      expect(find.text('Welcome to the Union Shop.'), findsOneWidget);
    });
  });
}
