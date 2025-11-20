import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/layout.dart';

void main() {
  group('Layout Widgets', () {
    testWidgets('SiteHeader shows banner and nav items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SiteHeader()),
        ),
      );
      await tester.pump();

      expect(find.textContaining('BIG SALE!'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
      expect(find.text('The Printing Shack'), findsOneWidget);
      expect(find.text('SALES!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('SiteFooter displays all three columns', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: SiteFooter())),
        ),
      );
      await tester.pump();

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
      expect(find.text('SUBSCRIBE'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
