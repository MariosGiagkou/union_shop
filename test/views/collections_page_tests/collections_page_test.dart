import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections_page.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CollectionsPage - Overview', () {
    testWidgets('displays collections overview page', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Check for collections title
      expect(find.text('Collections'), findsOneWidget);
    });

    testWidgets('displays all collection categories', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Check for collection categories (displayed in uppercase)
      expect(find.text('SIGNATURE'), findsOneWidget);
      expect(find.text('SALE'), findsOneWidget);
      expect(find.text('MERCHANDISE'), findsOneWidget);
      expect(find.text('PERSONALISATION'), findsOneWidget);
      expect(find.text('PORTSMOUTH CITY'), findsOneWidget);
      expect(find.text('PRIDE'), findsOneWidget);
      expect(find.text('HALLOWEEN'), findsOneWidget);
      expect(find.text('GRADUATION'), findsOneWidget);
    });

    testWidgets('displays grid with correct structure', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Should have a GridView
      expect(find.byType(GridView), findsOneWidget);

      // Verify grid has 3 columns
      final GridView gridView = tester.widget(find.byType(GridView));
      if (gridView.gridDelegate is SliverGridDelegateWithFixedCrossAxisCount) {
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 3);
        expect(delegate.childAspectRatio, 1.0); // Square images
      }
    });

    testWidgets('has scrollable layout', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Page should have ScrollView
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('grid is constrained properly', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Grid should be constrained
      expect(find.byType(ConstrainedBox), findsWidgets);
    });
  });

  group('CollectionsPage - Responsive Layout', () {
    testWidgets('renders correctly on mobile screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Collections'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('renders correctly on tablet screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Collections'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('renders correctly on desktop screen', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Collections'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
    });
  });

  group('CollectionsPage - Category Tiles', () {
    testWidgets('category tiles are tappable', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Find InkWell or GestureDetector wrapping category tiles
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('category tiles display images', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // Should have images for each category
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('category tiles have text labels', (tester) async {
      await pumpWithProviders(
        tester,
        const CollectionsPage(),
      );
      await tester.pumpAndSettle();

      // All 8 categories should be visible (in uppercase)
      final textFinders = [
        'SIGNATURE',
        'SALE',
        'MERCHANDISE',
        'PERSONALISATION',
        'PORTSMOUTH CITY',
        'PRIDE',
        'HALLOWEEN',
        'GRADUATION'
      ];

      for (final text in textFinders) {
        expect(find.text(text), findsOneWidget,
            reason: 'Category "$text" should be visible');
      }
    });
  });
}
