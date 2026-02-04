import 'package:flutter_test/flutter_test.dart';
import 'package:flight_hours_app/core/constants/admin_messages.dart';
import 'package:flight_hours_app/core/constants/employee_messages.dart';
import 'package:flight_hours_app/core/constants/login_messages.dart';

void main() {
  group('AdminMessages', () {
    test('panelTitle should be non-empty', () {
      expect(AdminMessages.panelTitle, isNotEmpty);
      expect(AdminMessages.panelTitle, equals('Admin Panel'));
    });

    test('panelSubtitle should be non-empty', () {
      expect(AdminMessages.panelSubtitle, isNotEmpty);
    });

    test('welcomeTitle should contain Admin', () {
      expect(AdminMessages.welcomeTitle, contains('Admin'));
    });

    test('section titles should be non-empty', () {
      expect(AdminMessages.routeManagement, isNotEmpty);
      expect(AdminMessages.systemConfiguration, isNotEmpty);
      expect(AdminMessages.systemOverview, isNotEmpty);
    });

    test('management card titles should be non-empty', () {
      expect(AdminMessages.airlinesTitle, isNotEmpty);
      expect(AdminMessages.routesTitle, isNotEmpty);
      expect(AdminMessages.airlineRoutesTitle, isNotEmpty);
    });

    test('system configuration cards should be non-empty', () {
      expect(AdminMessages.airportsTitle, isNotEmpty);
      expect(AdminMessages.aircraftModelsTitle, isNotEmpty);
      expect(AdminMessages.systemSettingsTitle, isNotEmpty);
    });

    test('comingSoon should format correctly', () {
      final message = AdminMessages.comingSoon('Feature');
      expect(message, contains('Feature'));
      expect(message, contains('coming soon'));
    });

    test('profile menu titles should be non-empty', () {
      expect(AdminMessages.myProfileTitle, isNotEmpty);
      expect(AdminMessages.logoutTitle, isNotEmpty);
    });
  });

  group('EmployeeMessages', () {
    test('welcomeTitle should contain Pilot', () {
      expect(EmployeeMessages.welcomeTitle, contains('Pilot'));
    });

    test('welcomeSubtitle should be non-empty', () {
      expect(EmployeeMessages.welcomeSubtitle, isNotEmpty);
    });

    test('logbook titles should be non-empty', () {
      expect(EmployeeMessages.logbookTitle, isNotEmpty);
      expect(EmployeeMessages.logbookSubtitle, isNotEmpty);
    });

    test('profile menu titles should be non-empty', () {
      expect(EmployeeMessages.myProfileTitle, isNotEmpty);
      expect(EmployeeMessages.changePasswordTitle, isNotEmpty);
      expect(EmployeeMessages.logoutTitle, isNotEmpty);
    });

    test('admin panel titles should be non-empty', () {
      expect(EmployeeMessages.adminPanelTitle, isNotEmpty);
      expect(EmployeeMessages.adminPanelSubtitle, isNotEmpty);
    });
  });

  group('LoginMessages', () {
    test('email field labels should be non-empty', () {
      expect(LoginMessages.emailLabel, isNotEmpty);
      expect(LoginMessages.emailHint, isNotEmpty);
    });

    test('password field labels should be non-empty', () {
      expect(LoginMessages.passwordLabel, isNotEmpty);
      expect(LoginMessages.passwordHint, isNotEmpty);
    });

    test('loginButton should be non-empty', () {
      expect(LoginMessages.loginButton, isNotEmpty);
    });

    test('forgotPassword should be non-empty', () {
      expect(LoginMessages.forgotPassword, isNotEmpty);
    });

    test('registration link texts should be non-empty', () {
      expect(LoginMessages.noAccountText, isNotEmpty);
      expect(LoginMessages.registerLink, isNotEmpty);
    });

    test('loading states should be non-empty', () {
      expect(LoginMessages.loggingIn, isNotEmpty);
      expect(LoginMessages.syncingData, isNotEmpty);
    });

    test('success/error messages should be non-empty', () {
      expect(LoginMessages.loginSuccess, isNotEmpty);
      expect(LoginMessages.loginFailed, isNotEmpty);
    });
  });
}
