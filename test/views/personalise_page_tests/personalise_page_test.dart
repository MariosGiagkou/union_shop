import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/personalise_page.dart';

void main() {
  // Note: PersonalisePage requires Firebase Firestore to load product data.
  // These tests verify basic widget properties without full rendering.

  group('PersonalisePage - Basic Tests', () {
    testWidgets('page widget can be instantiated', (tester) async {
      const page = PersonalisePage();
      expect(page, isNotNull);
      expect(page, isA<StatefulWidget>());
    });

    testWidgets('page has correct widget type', (tester) async {
      const page = PersonalisePage();
      expect(page, isA<PersonalisePage>());
    });

    testWidgets('page is a StatefulWidget', (tester) async {
      const page = PersonalisePage();
      expect(page, isA<StatefulWidget>());
    });

    testWidgets('can create state', (tester) async {
      const page = PersonalisePage();
      final state = page.createState();
      expect(state, isNotNull);
    });
  });

  group('PersonalisePage - Widget Properties', () {
    testWidgets('widget has key property available', (tester) async {
      const page = PersonalisePage(key: Key('test-key'));
      expect(page.key, isNotNull);
      expect(page.key, equals(const Key('test-key')));
    });

    testWidgets('widget runtimeType is correct', (tester) async {
      const page = PersonalisePage();
      expect(page.runtimeType.toString(), equals('PersonalisePage'));
    });

    testWidgets('createState returns correct state type', (tester) async {
      const page = PersonalisePage();
      final state = page.createState();
      expect(state.runtimeType.toString(), contains('PersonalisePageState'));
    });
  });

  group('PersonalisePage - Type Checks', () {
    testWidgets('is a Widget', (tester) async {
      const page = PersonalisePage();
      expect(page, isA<Widget>());
    });

    testWidgets('is a StatefulWidget', (tester) async {
      const page = PersonalisePage();
      expect(page, isA<StatefulWidget>());
    });

    testWidgets('has correct inheritance', (tester) async {
      const page = PersonalisePage();
      // Verify type using isA matcher
      expect(page, isA<PersonalisePage>());
      expect(page, isA<StatefulWidget>());
      expect(page, isA<Widget>());
    });
  });

  group('PersonalisePage - Constructor', () {
    testWidgets('can be created with default constructor', (tester) async {
      const page = PersonalisePage();
      expect(page, isNotNull);
    });

    testWidgets('can be created with key parameter', (tester) async {
      const testKey = Key('personalise-page');
      const page = PersonalisePage(key: testKey);
      expect(page.key, equals(testKey));
    });

    testWidgets('uses const constructor', (tester) async {
      // Verify const constructor is available
      const page = PersonalisePage();
      expect(page, isNotNull);
    });
  });

  group('PersonalisePage - State Management', () {
    testWidgets('state can be created', (tester) async {
      const page = PersonalisePage();
      final state = page.createState();
      expect(state, isNotNull);
    });

    testWidgets('state is unique per widget', (tester) async {
      const page1 = PersonalisePage();
      const page2 = PersonalisePage();

      final state1 = page1.createState();
      final state2 = page2.createState();

      expect(identical(state1, state2), isFalse);
    });

    testWidgets('multiple createState calls return new instances',
        (tester) async {
      const page = PersonalisePage();

      final state1 = page.createState();
      final state2 = page.createState();

      expect(identical(state1, state2), isFalse);
    });
  });
}
