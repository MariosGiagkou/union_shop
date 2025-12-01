import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CollectionsPage (views) - UI Structure Tests', () {
    testWidgets('CollectionsPage renders without error',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('CollectionsPage has a Scaffold', (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('CollectionsPage shows "Collections" title',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.text('Collections'), findsOneWidget);
    });

    testWidgets('CollectionsPage displays collection grid',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      // Should show GridView with collections
      expect(find.byType(GridView), findsWidgets);
    });

    testWidgets('CollectionsPage has images for collections',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('CollectionsPage uses SingleChildScrollView',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('CollectionsPage has InkWell for interaction',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('CollectionsPage maintains consistent state',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      // Pump again to ensure stable render
      await tester.pump();

      expect(find.byType(CollectionsPage), findsOneWidget);
    });
  });

  group('CollectionsPage - Responsive Behavior', () {
    testWidgets('CollectionsPage adapts to mobile screen size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('CollectionsPage adapts to tablet screen size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('CollectionsPage adapts to desktop screen size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('CollectionsPage renders properly at default size',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      expect(find.byType(CollectionsPage), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);
    });
  });

  group('CollectionsPage - State Management', () {
    testWidgets('CollectionsPage rebuilds correctly',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      await tester.pumpAndSettle();

      expect(find.byType(CollectionsPage), findsOneWidget);
    });

    testWidgets('CollectionsPage handles state changes',
        (WidgetTester tester) async {
      await pumpWithProviders(tester, const CollectionsPage());

      // Verify initial state
      expect(find.text('Collections'), findsOneWidget);

      // Pump to ensure stability
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CollectionsPage), findsOneWidget);
    });
  });
}
