import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/repositories/cart_repository.dart';

/// Simple mock User for testing
class _MockUser {
  final String? email;
  _MockUser(this.email);
}

class MockAuthService extends ChangeNotifier implements AuthService {
  _MockUser? _mockUser;
  bool _isSignedIn = false;

  @override
  User? get currentUser =>
      null; // Firebase User is not mockable without mockito

  @override
  bool get isSignedIn => _isSignedIn;

  @override
  String? get userEmail => _mockUser?.email;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  /// Set the signed-in state for testing
  void setSignedIn(bool signedIn, {String? email}) {
    _isSignedIn = signedIn;
    if (signedIn && email != null) {
      _mockUser = _MockUser(email);
    } else {
      _mockUser = null;
    }
    notifyListeners();
  }

  @override
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    // Test credentials: test@example.com / password123
    if (email == 'test@example.com' && password == 'password123') {
      setSignedIn(true, email: email);
      return null;
    }
    throw 'Invalid credentials';
  }

  @override
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    setSignedIn(true, email: email);
    return null;
  }

  @override
  Future<void> signOut() async {
    setSignedIn(false);
  }
}

/// Wrap a widget with all necessary providers for testing
///
/// This wraps the widget with AuthService and CartRepository providers,
/// making them available to the widget tree.
///
/// Example:
/// ```dart
/// final widget = wrapWithProviders(
///   MyWidget(),
///   authService: createSignedInAuthService(),
/// );
/// ```
Widget wrapWithProviders(
  Widget child, {
  AuthService? authService,
  CartRepository? cartRepository,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>(
        create: (_) => authService ?? MockAuthService(),
      ),
      ChangeNotifierProvider<CartRepository>(
        create: (_) => cartRepository ?? CartRepository(),
      ),
    ],
    child: child,
  );
}

/// Pump a widget with all necessary providers and MaterialApp
///
/// This is a convenience function that wraps the widget with providers
/// and MaterialApp, then pumps it into the test widget tree.
///
/// Example:
/// ```dart
/// await pumpWithProviders(
///   tester,
///   MyWidget(),
///   authService: createSignedInAuthService(),
/// );
/// ```
Future<void> pumpWithProviders(
  WidgetTester tester,
  Widget child, {
  AuthService? authService,
  CartRepository? cartRepository,
}) async {
  await tester.pumpWidget(
    wrapWithProviders(
      MaterialApp(
        home: child,
      ),
      authService: authService,
      cartRepository: cartRepository,
    ),
  );
}

/// Create a mock AuthService with a signed-in user
MockAuthService createSignedInAuthService({String email = 'test@example.com'}) {
  final authService = MockAuthService();
  authService.setSignedIn(true, email: email);
  return authService;
}

/// Create a mock AuthService with a signed-out user
MockAuthService createSignedOutAuthService() {
  final authService = MockAuthService();
  authService.setSignedIn(false);
  return authService;
}

/// Create a CartRepository with test items
CartRepository createCartWithItems() {
  final cart = CartRepository();
  cart.addItem(
    productId: 'test-1',
    title: 'Test Product 1',
    price: 19.99,
    imageUrl: 'https://example.com/image1.jpg',
    quantity: 2,
  );
  cart.addItem(
    productId: 'test-2',
    title: 'Test Product 2',
    price: 29.99,
    imageUrl: 'https://example.com/image2.jpg',
    quantity: 1,
  );
  return cart;
}

/// Find a widget by its key
Finder findByKey(String key) => find.byKey(Key(key));

/// Find a text widget
Finder findText(String text) => find.text(text);

/// Find an icon
Finder findIcon(IconData icon) => find.byIcon(icon);

/// Find a widget by type
Finder findByType<T>() => find.byType(T);

/// Tap a widget and settle
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Enter text and settle
Future<void> enterTextAndSettle(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Scroll until visible
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder finder,
  double scrollDelta, {
  Finder? scrollable,
}) async {
  await tester.scrollUntilVisible(
    finder,
    scrollDelta,
    scrollable: scrollable ?? find.byType(Scrollable).first,
  );
}

/// Expect widget to exist
void expectWidgetExists(Finder finder) {
  expect(finder, findsOneWidget);
}

/// Expect widget to not exist
void expectWidgetNotExists(Finder finder) {
  expect(finder, findsNothing);
}

/// Expect multiple widgets to exist
void expectWidgetsExist(Finder finder, int count) {
  expect(finder, findsNWidgets(count));
}

/// Wait for a condition to be true
Future<void> waitFor(
  WidgetTester tester,
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
  Duration pollInterval = const Duration(milliseconds: 100),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(endTime)) {
      throw TimeoutException('Condition not met within timeout', timeout);
    }
    await tester.pump(pollInterval);
  }
}

/// Exception for timeout errors
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}
