import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('ProductCard', () {
    testWidgets('renders correctly with asset image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'Test Product',
              price: '£35.00',
              imageUrl: 'assets/images/pink_hoodie.webp',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('£35.00'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders correctly with network image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'Network Product',
              price: '£15.00',
              imageUrl: 'https://example.com/image.jpg',
            ),
          ),
        ),
      );
      await tester.pump(); // initial frame
      await tester
          .pump(const Duration(milliseconds: 150)); // allow loadingBuilder

      expect(find.text('Network Product'), findsOneWidget);
      expect(find.text('£15.00'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('without original price only shows current price',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'No Sale Product',
              price: '£12.00',
              imageUrl: 'https://example.com/image.jpg',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('£12.00'), findsOneWidget);
      expect(find.text('£50.00'), findsNothing);
    });

    testWidgets('hover underlines title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              title: 'Hover Test Product',
              price: '£9.99',
              imageUrl: 'assets/images/pink_hoodie.webp',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final titleFinder = find.text('Hover Test Product');
      final beforeHover = tester.widget<Text>(titleFinder);
      expect(beforeHover.style?.decoration, isNot(TextDecoration.underline));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(
          location: tester.getCenter(find.byType(ProductCard)));
      await gesture.moveTo(tester.getCenter(find.byType(ProductCard)));
      await tester.pumpAndSettle();

      final afterHover = tester.widget<Text>(titleFinder);
      expect(afterHover.style?.decoration, TextDecoration.underline);
    });

    testWidgets('view all button exists and has correct styling',
        (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pumpAndSettle();

      final buttonFinder = find.byKey(const Key('home:view-all'));
      expect(buttonFinder, findsOneWidget);

      // Scroll to make the button visible
      await tester.dragUntilVisible(
        buttonFinder,
        find.byType(SingleChildScrollView),
        const Offset(0, -50),
      );
      await tester.pumpAndSettle();

      // Verify button exists and has correct styling
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(
          button.style?.backgroundColor?.resolve({}), const Color(0xFF4d2963));
      expect(find.descendant(of: buttonFinder, matching: find.text('VIEW ALL')),
          findsOneWidget);
    });
  });
}
