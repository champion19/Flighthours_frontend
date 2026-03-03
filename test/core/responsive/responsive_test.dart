import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/responsive/responsive_padding.dart';
import 'package:flight_hours_app/core/responsive/responsive_breakpoints.dart';

void main() {
  group('ResponsiveBreakpoints', () {
    test('isMobile returns true for width <= 600', () {
      expect(ResponsiveBreakpoints.isMobile(600), isTrue);
      expect(ResponsiveBreakpoints.isMobile(300), isTrue);
      expect(ResponsiveBreakpoints.isMobile(601), isFalse);
    });

    test('isTablet returns true for 601-1024', () {
      expect(ResponsiveBreakpoints.isTablet(700), isTrue);
      expect(ResponsiveBreakpoints.isTablet(1024), isTrue);
      expect(ResponsiveBreakpoints.isTablet(600), isFalse);
      expect(ResponsiveBreakpoints.isTablet(1025), isFalse);
    });

    test('isDesktop returns true for > 1024', () {
      expect(ResponsiveBreakpoints.isDesktop(1025), isTrue);
      expect(ResponsiveBreakpoints.isDesktop(1024), isFalse);
    });
  });

  group('ResponsivePadding', () {
    test('page returns correct padding for desktop', () {
      final padding = ResponsivePadding.page(1200);
      expect(padding.left, 48);
      expect(padding.right, 48);
    });

    test('page returns correct padding for tablet', () {
      final padding = ResponsivePadding.page(800);
      expect(padding.left, 32);
      expect(padding.right, 32);
    });

    test('page returns correct padding for mobile', () {
      final padding = ResponsivePadding.page(400);
      expect(padding.left, 16);
    });

    test('horizontal returns correct padding for desktop', () {
      final padding = ResponsivePadding.horizontal(1200);
      expect(padding.left, 48);
    });

    test('horizontal returns correct padding for tablet', () {
      final padding = ResponsivePadding.horizontal(800);
      expect(padding.left, 32);
    });

    test('horizontal returns correct padding for mobile', () {
      final padding = ResponsivePadding.horizontal(400);
      expect(padding.left, 16);
    });

    test('constrainedContent returns centered widget', () {
      final widget = ResponsivePadding.constrainedContent(
        child: const SizedBox(),
      );
      expect(widget, isA<Center>());
    });
  });
}
