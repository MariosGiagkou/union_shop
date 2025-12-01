import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/about_us_printshack.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('PrintShackAboutPage - Basic Structure', () {
    testWidgets('page displays main heading', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(find.text('About us'), findsOneWidget);
    });

    testWidgets('page displays Print Shack logo image', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      // Check for the image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('page displays all section headings', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(
          find.text('Make It Yours at The Union Print Shack'), findsOneWidget);
      expect(find.text('Uni Gear or Your Gear - We\'ll Personalise It'),
          findsOneWidget);
      expect(find.text('Simple Pricing, No Surprises'), findsOneWidget);
      expect(find.text('Personalisation Terms & Conditions'), findsOneWidget);
      expect(find.text('Ready to Make It Yours?'), findsOneWidget);
    });

    testWidgets('page displays pricing information', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(find.textContaining('£3 for one line of text'), findsOneWidget);
      expect(find.textContaining('£5 for two lines'), findsOneWidget);
    });
  });

  group('PrintShackAboutPage - Layout', () {
    testWidgets('uses Scaffold with scrollable body', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('has constrained content width', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      final constrainedBoxFinder = find.byType(ConstrainedBox);
      expect(constrainedBoxFinder, findsAtLeastNWidgets(1));

      // Find the main content ConstrainedBox (maxWidth: 960)
      final constrainedBoxes =
          tester.widgetList<ConstrainedBox>(constrainedBoxFinder);
      final hasMaxWidth960 = constrainedBoxes.any(
        (box) => box.constraints.maxWidth == 960,
      );
      expect(hasMaxWidth960, isTrue);
    });

    testWidgets('content is properly padded', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      // Find Container with padding
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsAtLeastNWidgets(1));
    });
  });

  group('PrintShackAboutPage - Content', () {
    testWidgets('displays terms and conditions text', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(
        find.textContaining(
            'We will print your clothing exactly as you have provided'),
        findsOneWidget,
      );
      expect(
        find.textContaining(
            'Refunds are not provided for any personalised items'),
        findsOneWidget,
      );
    });

    testWidgets('displays turnaround time information', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(
        find.textContaining('up to three working days'),
        findsOneWidget,
      );
    });

    testWidgets('explains personalisation service', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      expect(
        find.textContaining('heat-pressed customisation'),
        findsOneWidget,
      );
      expect(
        find.textContaining('official uni-branded clothing'),
        findsOneWidget,
      );
    });
  });

  group('PrintShackAboutPage - Widget Properties', () {
    testWidgets('is a StatelessWidget', (tester) async {
      const page = PrintShackAboutPage();
      expect(page, isA<StatelessWidget>());
    });

    testWidgets('can be instantiated', (tester) async {
      const page = PrintShackAboutPage();
      expect(page, isNotNull);
    });

    testWidgets('can be created with key parameter', (tester) async {
      const testKey = Key('printshack-page');
      const page = PrintShackAboutPage(key: testKey);
      expect(page.key, equals(testKey));
    });
  });

  group('PrintShackAboutPage - Styling', () {
    testWidgets('main heading has correct font size', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      final textFinder = find.text('About us');
      final textWidget = tester.widget<Text>(textFinder);

      expect(textWidget.style?.fontSize, equals(34));
      expect(textWidget.style?.fontWeight, equals(FontWeight.w700));
    });

    testWidgets('section headings have correct font size', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      final headingFinder = find.text('Make It Yours at The Union Print Shack');
      final headingWidget = tester.widget<Text>(headingFinder);

      expect(headingWidget.style?.fontSize, equals(24));
      expect(headingWidget.style?.fontWeight, equals(FontWeight.w700));
    });

    testWidgets('has proper spacing between sections', (tester) async {
      await pumpWithProviders(tester, const PrintShackAboutPage());
      await tester.pump();

      // Check for SizedBox spacing
      final sizedBoxFinder = find.byType(SizedBox);
      expect(sizedBoxFinder, findsAtLeastNWidgets(5));
    });
  });
}
