import 'package:flight_hours_app/core/responsive/responsive_breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveBreakpoints', () {
    group('isMobile', () {
      test('returns true for width 0', () {
        expect(ResponsiveBreakpoints.isMobile(0), isTrue);
      });

      test('returns true for width 400', () {
        expect(ResponsiveBreakpoints.isMobile(400), isTrue);
      });

      test('returns true for width exactly 600 (boundary)', () {
        expect(ResponsiveBreakpoints.isMobile(600), isTrue);
      });

      test('returns false for width 601', () {
        expect(ResponsiveBreakpoints.isMobile(601), isFalse);
      });

      test('returns false for width 1200', () {
        expect(ResponsiveBreakpoints.isMobile(1200), isFalse);
      });
    });

    group('isTablet', () {
      test('returns false for width 600 (mobile boundary)', () {
        expect(ResponsiveBreakpoints.isTablet(600), isFalse);
      });

      test('returns true for width 601', () {
        expect(ResponsiveBreakpoints.isTablet(601), isTrue);
      });

      test('returns true for width 800', () {
        expect(ResponsiveBreakpoints.isTablet(800), isTrue);
      });

      test('returns true for width exactly 1024 (boundary)', () {
        expect(ResponsiveBreakpoints.isTablet(1024), isTrue);
      });

      test('returns false for width 1025', () {
        expect(ResponsiveBreakpoints.isTablet(1025), isFalse);
      });

      test('returns false for width 400', () {
        expect(ResponsiveBreakpoints.isTablet(400), isFalse);
      });
    });

    group('isDesktop', () {
      test('returns false for width 1024 (tablet boundary)', () {
        expect(ResponsiveBreakpoints.isDesktop(1024), isFalse);
      });

      test('returns true for width 1025', () {
        expect(ResponsiveBreakpoints.isDesktop(1025), isTrue);
      });

      test('returns true for width 1920', () {
        expect(ResponsiveBreakpoints.isDesktop(1920), isTrue);
      });

      test('returns false for width 400', () {
        expect(ResponsiveBreakpoints.isDesktop(400), isFalse);
      });

      test('returns false for width 800', () {
        expect(ResponsiveBreakpoints.isDesktop(800), isFalse);
      });
    });

    group('mutual exclusivity', () {
      test('exactly one returns true for any given width', () {
        final testWidths = [0, 300, 600, 601, 800, 1024, 1025, 1920];
        for (final w in testWidths) {
          final results = [
            ResponsiveBreakpoints.isMobile(w.toDouble()),
            ResponsiveBreakpoints.isTablet(w.toDouble()),
            ResponsiveBreakpoints.isDesktop(w.toDouble()),
          ];
          expect(
            results.where((r) => r).length,
            1,
            reason:
                'Width $w should match exactly one breakpoint, '
                'got: mobile=${results[0]}, tablet=${results[1]}, desktop=${results[2]}',
          );
        }
      });
    });

    group('constants', () {
      test('mobileMaxWidth is 600', () {
        expect(ResponsiveBreakpoints.mobileMaxWidth, 600);
      });

      test('tabletMaxWidth is 1024', () {
        expect(ResponsiveBreakpoints.tabletMaxWidth, 1024);
      });
    });
  });
}
