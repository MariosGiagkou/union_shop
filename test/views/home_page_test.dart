import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

Widget _buildTestApp() => MaterialApp(
      routes: {
        '/product': (_) => const Scaffold(
              body: Center(child: Text('Product Page')),
            ),
      },
      home: const HomePage(),
    );

void main() {
  testWidgets('HomePage renders hero section and primary headings',
      (tester) async {
    await tester.pumpWidget(_buildTestApp());
    expect(find.text('Placeholder Hero Title'), findsOneWidget);
    expect(find.text('ESSENTIAL RANGE - OVER 20% OFF!'), findsOneWidget);
    expect(find.text('OUR RANGE'), findsOneWidget);
  });

  testWidgets(
      'HomePage shows expected number of product cards (wide layout assumed)',
      (tester) async {
    await tester.pumpWidget(_buildTestApp());
    await tester.pump(); // settle
    // ProductCard widgets: 2 + 2 + 2 + 2 = 8
    expect(find.byType(ProductCard), findsNWidgets(8));
  });

  testWidgets('HomePage shows 4 category cards', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    expect(find.byType(RangeCategoryCard), findsNWidgets(4));
  });

  testWidgets('Personalization section present with button', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    expect(find.text('Add a Personal Touch'), findsOneWidget);
    expect(find.text('CLICK HERE TO ADD TEXT!'), findsOneWidget);
  });

  testWidgets('Tapping a product navigates to /product', (tester) async {
    await tester.pumpWidget(_buildTestApp());
    final titleFinder = find.text('Limited Edition Essential Zip Hoodies');
    // Bring first matching product title into view (handles multiple matches gracefully).
    final singleTitleFinder = titleFinder.first;
    await tester.ensureVisible(singleTitleFinder);
    await tester.tap(singleTitleFinder);
    await tester.pumpAndSettle();
    expect(find.text('Product Page'), findsOneWidget);
  });
}
