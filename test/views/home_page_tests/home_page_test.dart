import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('HomePage renders hero section and primary headings',
      (tester) async {
    await pumpWithProviders(tester, const HomePage());
    await tester.pumpAndSettle();
    // Updated first slide text; accept either first or second slide
    final hero1 = find.text('essential range 20% OFF');
    final hero2 = find.text('Personalised Hoodie');
    expect(hero1.evaluate().isNotEmpty || hero2.evaluate().isNotEmpty, isTrue,
        reason:
            'Expected either updated first slide or second slide hero text to be visible');
    expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
    expect(find.text('OUR RANGE'), findsOneWidget);
  });

  testWidgets(
      'HomePage shows expected number of product cards (wide layout assumed)',
      (tester) async {
    await pumpWithProviders(tester, const HomePage());
    await tester.pump(); // settle
    // ProductCard widgets: 2 + 2 + 2 + 2 = 8
    expect(find.byType(ProductCard), findsNWidgets(8));
  },
      skip:
          true); // Requires Firestore mocking - ProductCards load from real Firestore data

  testWidgets('HomePage shows 4 category cards', (tester) async {
    await pumpWithProviders(tester, const HomePage());
    expect(find.byType(RangeCategoryCard), findsNWidgets(4));
  });

  testWidgets('Personalization section present with button', (tester) async {
    await pumpWithProviders(tester, const HomePage());
    expect(find.text('Add a Personal Touch'), findsOneWidget);
    expect(find.text('CLICK HERE TO ADD TEXT!'), findsOneWidget);
  });

  group('Hero carousel controls', () {
    testWidgets('Left/right arrows, dots and pause button are present',
        (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pump();

      // Arrows
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      // Pause icon (starts in pause state)
      expect(find.byIcon(Icons.pause), findsOneWidget);

      // Dot indicators: filter AnimatedContainers that are circular and small
      final dotFinder = find.byWidgetPredicate((w) {
        if (w is AnimatedContainer && w.decoration is BoxDecoration) {
          final d = w.decoration as BoxDecoration;
          return d.shape == BoxShape.circle;
        }
        return false;
      });
      expect(dotFinder, findsNWidgets(2));
    });

    testWidgets('Right arrow advances to second slide with personalised text',
        (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pumpAndSettle();
      // Ensure starting from first slide; if already on second slide, navigate left
      if (find.text('Personalised Hoodie').evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pump(const Duration(milliseconds: 700));
      }
      expect(find.text('essential range 20% OFF'), findsOneWidget);
      // Tap right arrow
      await tester.tap(find.byIcon(Icons.chevron_right));
      // Allow page animation to finish
      // Pump in increments until second slide text appears or timeout
      bool found = false;
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 120));
        if (find.text('Personalised Hoodie').evaluate().isNotEmpty) {
          found = true;
          break;
        }
      }
      expect(found, isTrue,
          reason: 'Second slide text not found after navigation');
    });

    testWidgets('Pause button toggles to play and back', (tester) async {
      await pumpWithProviders(tester, const HomePage());
      await tester.pump();
      final pauseIcon = find.byIcon(Icons.pause);
      expect(pauseIcon, findsOneWidget);
      await tester.tap(pauseIcon);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      // Tap again to re-enable auto-rotate
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });
}
