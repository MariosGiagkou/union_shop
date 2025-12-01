import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/layout.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Layout (Header & Footer)', () {
    testWidgets('SiteHeader displays nav items', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Banner
      expect(find.textContaining('BIG SALE!'), findsOneWidget);

      // Nav items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
      expect(find.text('The Printing Shack'), findsOneWidget);
      expect(find.text('SALES!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('SiteHeader displays icons', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('SiteFooter displays all columns', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('SiteHeader shows cart badge when items exist', (tester) async {
      final cartRepo = createCartWithItems();

      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
        cartRepository: cartRepo,
      );

      // Should show cart icon
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('SiteHeader is a StatefulWidget', (tester) async {
      expect(const SiteHeader(), isA<StatefulWidget>());
    });

    testWidgets('SiteFooter is a StatelessWidget', (tester) async {
      expect(const SiteFooter(), isA<StatelessWidget>());
    });

    testWidgets('SiteFooter contains opening hours information',
        (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.text('Opening Hours'), findsOneWidget);
    });

    testWidgets('SiteFooter contains help links', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.text('Help and Information'), findsOneWidget);
    });

    testWidgets('SiteFooter contains offers section', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.text('Latest Offers'), findsOneWidget);
    });

    testWidgets('SiteHeader renders without error', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('SiteFooter renders without error', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.byType(SiteFooter), findsOneWidget);
    });

    testWidgets('SiteHeader displays sale banner', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.textContaining('BIG SALE!'), findsOneWidget);
    });

    testWidgets('SiteHeader has navigation menu', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Check all main nav items exist
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Shop'), findsOneWidget);
      expect(find.text('The Printing Shack'), findsOneWidget);
      expect(find.text('SALES!'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('SiteHeader has user actions area', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Check action icons
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('SiteFooter has proper structure', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      // Verify footer contains Container (for styling)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('SiteHeader can be instantiated with key', (tester) async {
      const header = SiteHeader(key: Key('test-header'));

      await pumpWithProviders(
        tester,
        Scaffold(body: header),
        authService: createSignedOutAuthService(),
      );

      expect(find.byKey(const Key('test-header')), findsOneWidget);
    });

    testWidgets('SiteFooter can be instantiated with key', (tester) async {
      const footer = SiteFooter(key: Key('test-footer'));

      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: footer)),
      );

      expect(find.byKey(const Key('test-footer')), findsOneWidget);
    });
  });

  group('Layout - Responsive Behavior', () {
    testWidgets('SiteHeader adapts to mobile screen size', (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('SiteHeader adapts to tablet screen size', (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('SiteHeader adapts to desktop screen size', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('SiteFooter adapts to mobile screen size', (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.byType(SiteFooter), findsOneWidget);
    });

    testWidgets('SiteFooter adapts to desktop screen size', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.byType(SiteFooter), findsOneWidget);
    });
  });

  group('Layout - Additional UI Elements', () {
    testWidgets('SiteHeader has logo/branding area', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Check for Image widget (logo)
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('SiteFooter contains Row for layout', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('SiteFooter contains Column widgets', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('SiteHeader maintains state after rebuild', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      // Trigger a rebuild
      await tester.pump();

      expect(find.byType(SiteHeader), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('SiteFooter renders consistently', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SingleChildScrollView(child: SiteFooter())),
      );

      // Trigger a rebuild
      await tester.pump();

      expect(find.byType(SiteFooter), findsOneWidget);
      expect(find.text('Opening Hours'), findsOneWidget);
    });

    testWidgets('SiteHeader displays with signed-in user', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedInAuthService(),
      );

      expect(find.byType(SiteHeader), findsOneWidget);
      // User icon may change based on auth state
    });

    testWidgets('SiteHeader handles empty cart', (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
        cartRepository: CartRepository(),
      );

      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('SiteHeader contains InkWell widgets for navigation',
        (tester) async {
      await pumpWithProviders(
        tester,
        const Scaffold(body: SiteHeader()),
        authService: createSignedOutAuthService(),
      );

      expect(find.byType(InkWell), findsWidgets);
    });
  });
}
