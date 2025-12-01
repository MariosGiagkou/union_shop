import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/auth_service.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth(signedIn: false);
    authService = AuthService(auth: mockAuth);
  });

  tearDown(() {
    // Safe disposal
    try {
      authService.dispose();
    } catch (_) {}
  });

  group('Constructor and Initial State', () {
    test('creates instance with default FirebaseAuth when no auth provided',
        () {
      final service = AuthService();
      expect(service, isNotNull);
      expect(service, isA<AuthService>());
    });

    test('creates instance with mocked FirebaseAuth', () {
      expect(authService, isNotNull);
      expect(authService, isA<AuthService>());
    });

    test('initial state is not signed in when mock is not signed in', () {
      expect(authService.isSignedIn, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('initial state is signed in when mock is signed in', () async {
      final signedInMock = MockFirebaseAuth(signedIn: true);
      final signedInService = AuthService(auth: signedInMock);

      // Give auth state listener time to settle
      await Future.delayed(const Duration(milliseconds: 10));

      expect(signedInService.isSignedIn, isTrue);
      expect(signedInService.currentUser, isNotNull);

      try {
        signedInService.dispose();
      } catch (_) {}
    });
  });

  group('Sign In', () {
    test('signIn changes signed in state to true', () async {
      expect(authService.isSignedIn, isFalse);

      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Give auth state listener time to settle
      await Future.delayed(const Duration(milliseconds: 10));

      expect(authService.isSignedIn, isTrue);
      expect(authService.currentUser, isNotNull);
    });

    test('signIn returns UserCredential', () async {
      final result = await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, isNotNull);
      expect(result?.user, isNotNull);
    });

    test('signIn accepts valid email formats', () async {
      final result = await authService.signIn(
        email: 'user@test.co.uk',
        password: 'password',
      );
      expect(result, isNotNull);
    });

    test('multiple sign ins work consecutively', () async {
      await authService.signIn(
        email: 'user1@example.com',
        password: 'pass1',
      );
      await authService.signOut();

      await authService.signIn(
        email: 'user2@example.com',
        password: 'pass2',
      );

      expect(authService.isSignedIn, isTrue);
    });
  });

  group('Sign Up', () {
    test('signUp changes signed in state to true', () async {
      expect(authService.isSignedIn, isFalse);

      await authService.signUp(
        email: 'newuser@example.com',
        password: 'password123',
      );

      // Give auth state listener time to settle
      await Future.delayed(const Duration(milliseconds: 10));

      expect(authService.isSignedIn, isTrue);
      expect(authService.currentUser, isNotNull);
    });

    test('signUp returns UserCredential', () async {
      final result = await authService.signUp(
        email: 'newuser@example.com',
        password: 'password123',
      );

      expect(result, isNotNull);
      expect(result?.user, isNotNull);
    });

    test('signUp accepts various email formats', () async {
      final result = await authService.signUp(
        email: 'test.user+tag@example.com',
        password: 'strongPass123',
      );
      expect(result, isNotNull);
    });
  });

  group('Sign Out', () {
    test('signOut changes signed in state to false', () async {
      // First sign in
      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Give auth state listener time to settle
      await Future.delayed(const Duration(milliseconds: 10));

      expect(authService.isSignedIn, isTrue);

      // Then sign out
      await authService.signOut();

      // Give auth state listener time to settle
      await Future.delayed(const Duration(milliseconds: 10));

      expect(authService.isSignedIn, isFalse);
      expect(authService.currentUser, isNull);
    });

    test('signOut completes without error', () async {
      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(() => authService.signOut(), returnsNormally);
    });

    test('signOut when already signed out does not cause error', () async {
      expect(authService.isSignedIn, isFalse);
      expect(() => authService.signOut(), returnsNormally);
    });
  });

  group('Getters', () {
    test('currentUser is null when not signed in', () {
      expect(authService.currentUser, isNull);
    });

    test('currentUser is not null when signed in', () async {
      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(authService.currentUser, isNotNull);
    });

    test('isSignedIn returns false when not signed in', () {
      expect(authService.isSignedIn, isFalse);
    });

    test('isSignedIn returns true when signed in', () async {
      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(authService.isSignedIn, isTrue);
    });

    test('userEmail is null when not signed in', () {
      expect(authService.userEmail, isNull);
    });

    test('authStateChanges stream is available', () {
      expect(authService.authStateChanges, isNotNull);
      expect(authService.authStateChanges, isA<Stream<dynamic>>());
    });
  });

  group('Complete Authentication Flow', () {
    test('sign up, sign out, sign in flow works correctly', () async {
      // Sign up
      await authService.signUp(
        email: 'flow@example.com',
        password: 'password123',
      );
      await Future.delayed(const Duration(milliseconds: 10));
      expect(authService.isSignedIn, isTrue);

      // Sign out
      await authService.signOut();
      await Future.delayed(const Duration(milliseconds: 10));
      expect(authService.isSignedIn, isFalse);

      // Sign in
      await authService.signIn(
        email: 'flow@example.com',
        password: 'password123',
      );
      await Future.delayed(const Duration(milliseconds: 10));
      expect(authService.isSignedIn, isTrue);
    });

    test('multiple sign in/out cycles maintain correct state', () async {
      for (int i = 0; i < 3; i++) {
        await authService.signIn(
          email: 'cycle@example.com',
          password: 'pass',
        );
        await Future.delayed(const Duration(milliseconds: 10));
        expect(authService.isSignedIn, isTrue);

        await authService.signOut();
        await Future.delayed(const Duration(milliseconds: 10));
        expect(authService.isSignedIn, isFalse);
      }
    });
  });

  group('ChangeNotifier Behavior', () {
    test('notifies listeners on sign in', () async {
      int notifyCount = 0;
      authService.addListener(() {
        notifyCount++;
      });

      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      // Give listener time to fire
      await Future.delayed(const Duration(milliseconds: 10));

      expect(notifyCount, greaterThan(0));
    });

    test('notifies listeners on sign out', () async {
      await authService.signIn(
        email: 'test@example.com',
        password: 'password123',
      );
      await Future.delayed(const Duration(milliseconds: 10));

      int notifyCount = 0;
      authService.addListener(() {
        notifyCount++;
      });

      await authService.signOut();
      await Future.delayed(const Duration(milliseconds: 10));

      expect(notifyCount, greaterThan(0));
    });
  });
}
