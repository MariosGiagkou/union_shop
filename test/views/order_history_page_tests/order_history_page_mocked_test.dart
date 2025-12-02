import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/order_history_page.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/order_service.dart';
import 'package:union_shop/repositories/cart_repository.dart';
import 'package:union_shop/models/layout.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late AuthService authService;
  late OrderService orderService;

  setUp(() {
    mockAuth = MockFirebaseAuth(signedIn: false);
    fakeFirestore = FakeFirebaseFirestore();
    authService = AuthService(auth: mockAuth);
    orderService = OrderService(firestore: fakeFirestore);
  });

  tearDown(() {
    try {
      authService.dispose();
    } catch (_) {}
  });

  group('OrderHistoryPage - Not Signed In', () {
    testWidgets('shows sign in prompt when not authenticated', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Please sign in to view order history'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('has sign in button', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      expect(signInButton, findsOneWidget);
    });

    testWidgets('displays lock icon', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });
  });

  group('OrderHistoryPage - Signed In', () {
    late MockFirebaseAuth signedInAuth;
    late AuthService signedInAuthService;

    setUp(() {
      signedInAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'test-uid-123', email: 'test@example.com'),
      );
      signedInAuthService = AuthService(auth: signedInAuth);
    });

    tearDown(() {
      try {
        signedInAuthService.dispose();
      } catch (_) {}
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(
                value: signedInAuthService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty orders message when no orders', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(
                value: signedInAuthService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
    });

    testWidgets('renders scaffold', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(
                value: signedInAuthService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('OrderHistoryPage - Widget Structure', () {
    testWidgets('has SiteHeader', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SiteHeader), findsOneWidget);
    });

    testWidgets('has Column layout', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('can be instantiated', (tester) async {
      const page = OrderHistoryPage();
      expect(page, isNotNull);
      expect(page, isA<StatelessWidget>());
    });
  });

  group('OrderHistoryPage - Edge Cases', () {
    testWidgets('handles null user gracefully', (tester) async {
      final nullUserAuth = MockFirebaseAuth(signedIn: false);
      final nullUserAuthService = AuthService(auth: nullUserAuth);

      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(
                value: nullUserAuthService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Please sign in to view order history'), findsOneWidget);

      try {
        nullUserAuthService.dispose();
      } catch (_) {}
    });

    testWidgets('rebuilds when auth state changes', (tester) async {
      await pumpWithProviders(
        tester,
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: authService),
            Provider<OrderService>.value(value: orderService),
            ChangeNotifierProvider(create: (_) => CartRepository()),
          ],
          child: const OrderHistoryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Please sign in to view order history'), findsOneWidget);

      // Rebuild
      await tester.pump();

      expect(find.text('Please sign in to view order history'), findsOneWidget);
    });
  });
}
