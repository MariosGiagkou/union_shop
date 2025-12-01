import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/about_us.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AboutUsPage content', () {
    testWidgets('renders all expected text blocks', (tester) async {
      await pumpWithProviders(tester, const AboutUsPage());
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

  group('AboutUsPage layout', () {
    testWidgets('renders with header and footer', (tester) async {
      await pumpWithProviders(tester, const AboutUsPage());
      await tester.pumpAndSettle();

      // Verify header is present (sale banner text)
      expect(
        find.text(
          'BIG SALE! OUR ESSENTIAL RANGE HAS DROPPED IN PRICE! OVER 20% OFF! COME GRAB YOURS WHILE STOCK LASTS!',
        ),
        findsOneWidget,
      );

      // Verify footer sections are present
      expect(find.text('Opening Hours'), findsOneWidget);
      expect(find.text('Help and Information'), findsOneWidget);
      expect(find.text('Latest Offers'), findsOneWidget);
    });
  });
}
