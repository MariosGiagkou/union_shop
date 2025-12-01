import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service for handling Firebase Authentication
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get current user email
  String? get userEmail => currentUser?.email;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    // Listen to auth state changes and notify listeners
    _auth.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }

  /// Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email address.';
      } else if (e.code == 'user-disabled') {
        throw 'This user account has been disabled.';
      } else {
        throw 'Sign in failed: ${e.message}';
      }
    } catch (e) {
      throw 'An error occurred: $e';
    }
  }

  /// Sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email address.';
      } else {
        throw 'Sign up failed: ${e.message}';
      }
    } catch (e) {
      throw 'An error occurred: $e';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw 'Sign out failed: $e';
    }
  }
}
