import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/constants/admin_messages.dart';

void main() {
  group('AdminMessages', () {
    group('header constants', () {
      test('should have panel title', () {
        expect(AdminMessages.panelTitle, equals('Admin Panel'));
      });

      test('should have panel subtitle', () {
        expect(AdminMessages.panelSubtitle, equals('System Administration'));
      });
    });

    group('welcome card constants', () {
      test('should have welcome title', () {
        expect(AdminMessages.welcomeTitle, equals('Welcome, Admin!'));
      });

      test('should have welcome subtitle', () {
        expect(AdminMessages.welcomeSubtitle, isNotEmpty);
      });
    });

    group('management card constants', () {
      test('should have airlines title and subtitle', () {
        expect(AdminMessages.airlinesTitle, equals('Airlines'));
        expect(AdminMessages.airlinesSubtitle, isNotEmpty);
      });

      test('should have routes title and subtitle', () {
        expect(AdminMessages.routesTitle, equals('Routes'));
        expect(AdminMessages.routesSubtitle, isNotEmpty);
      });

      test('should have airline routes title and subtitle', () {
        expect(AdminMessages.airlineRoutesTitle, equals('Airline Routes'));
        expect(AdminMessages.airlineRoutesSubtitle, isNotEmpty);
      });
    });

    group('system configuration constants', () {
      test('should have airports title', () {
        expect(AdminMessages.airportsTitle, equals('Airports'));
      });

      test('should have aircraft models title', () {
        expect(AdminMessages.aircraftModelsTitle, equals('Aircraft Models'));
      });

      test('should have system settings title', () {
        expect(AdminMessages.systemSettingsTitle, equals('System Settings'));
      });
    });

    group('comingSoon helper', () {
      test('should return formatted coming soon message', () {
        final result = AdminMessages.comingSoon('Feature X');
        expect(result, equals('Feature X coming soon!'));
      });

      test('should work with any feature name', () {
        expect(
          AdminMessages.comingSoon('Settings'),
          equals('Settings coming soon!'),
        );
        expect(
          AdminMessages.comingSoon('Reports'),
          equals('Reports coming soon!'),
        );
      });
    });

    group('profile menu constants', () {
      test('should have logout title and subtitle', () {
        expect(AdminMessages.logoutTitle, equals('Log out'));
        expect(AdminMessages.logoutSubtitle, isNotEmpty);
      });

      test('should have my profile title and subtitle', () {
        expect(AdminMessages.myProfileTitle, equals('My Profile'));
        expect(AdminMessages.myProfileSubtitle, isNotEmpty);
      });
    });
  });
}
