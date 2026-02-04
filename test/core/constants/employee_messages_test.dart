import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/constants/employee_messages.dart';

void main() {
  group('EmployeeMessages', () {
    group('welcome section constants', () {
      test('should have welcome title', () {
        expect(EmployeeMessages.welcomeTitle, equals('Welcome, Pilot!'));
      });

      test('should have welcome subtitle', () {
        expect(EmployeeMessages.welcomeSubtitle, isNotEmpty);
      });
    });

    group('logbook constants', () {
      test('should have logbook title', () {
        expect(EmployeeMessages.logbookTitle, equals('My Logbook'));
      });

      test('should have logbook subtitle', () {
        expect(EmployeeMessages.logbookSubtitle, isNotEmpty);
      });
    });

    group('help text constants', () {
      test('should have menu help text', () {
        expect(EmployeeMessages.menuHelpText, isNotEmpty);
        expect(EmployeeMessages.menuHelpText, contains('menu'));
      });
    });

    group('profile menu constants', () {
      test('should have my profile title and subtitle', () {
        expect(EmployeeMessages.myProfileTitle, equals('My Profile'));
        expect(EmployeeMessages.myProfileSubtitle, isNotEmpty);
      });

      test('should have change password title and subtitle', () {
        expect(EmployeeMessages.changePasswordTitle, equals('Change Password'));
        expect(EmployeeMessages.changePasswordSubtitle, isNotEmpty);
      });

      test('should have logout title and subtitle', () {
        expect(EmployeeMessages.logoutTitle, equals('Log out'));
        expect(EmployeeMessages.logoutSubtitle, isNotEmpty);
      });
    });

    group('admin panel constants', () {
      test('should have admin panel title and subtitle', () {
        expect(EmployeeMessages.adminPanelTitle, equals('Admin Panel'));
        expect(EmployeeMessages.adminPanelSubtitle, isNotEmpty);
      });
    });
  });
}
