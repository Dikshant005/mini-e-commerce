import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_shop_simple/main.dart' as app;
import 'package:my_shop_simple/features/products/products_detail_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('auto-login → products → tap card → detail page', (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 3)); // let auto-login finish

    print('Auto-login should be complete. Checking for GridView...');

    /* ---- WAIT FOR PRODUCTS (skip login entirely) ---- */
    try {
      await tester.pumpUntil(find.descendant(
        of: find.byType(GridView),
        matching: find.byType(Card),
      ), timeout: Duration(seconds: 30)); // Increased timeout for debugging
      print('GridView found.');
    } catch (e) {
      print('GridView not found within timeout: $e');
      rethrow; // Re-throw the exception to fail the test
    }

    /* ---- TAP FIRST PRODUCT CARD ---- */
    try {
      await tester.tap(find.descendant(
        of: find.byType(GridView),
        matching: find.byType(Card),
      ).first);
      await tester.pumpAndSettle();
      print('First product card tapped.');
    } catch (e) {
      print('Failed to tap first product card: $e');
      rethrow; // Re-throw the exception to fail the test
    }

    /* ---- VERIFY DETAIL PAGE ---- */
    try {
      expect(find.byType(ProductDetailPage), findsOneWidget);
      print('ProductDetailPage found. Test passed.');
    } catch (e) {
      print('ProductDetailPage not found: $e');
      rethrow; // Re-throw the exception to fail the test
    }
  });
}

extension WaitUntil on WidgetTester {
  Future<void> pumpUntil(Finder finder, {Duration timeout = const Duration(seconds: 30)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        print('Finder found: ${finder.toString()}');
        return;
      }
      print('Waiting for finder: ${finder.toString()}');
    }
    throw StateError('Finder did not appear within $timeout');
  }
}