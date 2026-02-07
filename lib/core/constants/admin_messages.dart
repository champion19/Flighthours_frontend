/// Constantes de mensajes para el feature de Admin
class AdminMessages {
  // Header
  static const String panelTitle = 'Admin Panel';
  static const String panelSubtitle = 'System Administration';

  // Welcome card
  static const String welcomeTitle = 'Welcome, Admin!';
  static const String welcomeSubtitle =
      'Manage your flight hours system from here';

  // Section titles
  static const String routeManagement = 'Route Management';
  static const String systemConfiguration = 'System Configuration';
  static const String systemOverview = 'System Overview'; // Removido de UI

  // Management cards
  static const String airlinesTitle = 'Airlines';
  static const String airlinesSubtitle = 'Activate or deactivate airlines';
  static const String routesTitle = 'Routes';
  static const String routesSubtitle = 'View all flight routes';
  static const String airlineRoutesTitle = 'Airline Routes';
  static const String airlineRoutesSubtitle =
      'Activate or deactivate airline routes';

  // System configuration cards
  static const String airportsTitle = 'Airports';
  static const String aircraftModelsTitle = 'Aircraft Models';
  static const String aircraftModelsSubtitle =
      'Activate or deactivate aircraft models';
  static const String aircraftFamiliesTitle = 'Aircraft Families';
  static const String systemSettingsTitle = 'System Settings';

  // Snackbar messages
  static const String comingSoonSuffix = 'coming soon!';
  static String comingSoon(String feature) => '$feature $comingSoonSuffix';

  // System Overview stats (Removidos de UI pero guardados para futuro)
  static const String usersLabel = 'Users';
  static const String airlinesLabel = 'Airlines';
  static const String routesLabel = 'Routes';

  // Profile menu (Simplificado a solo logout en UI)
  static const String myProfileTitle = 'My Profile';
  static const String myProfileSubtitle = 'View admin info';
  static const String logoutTitle = 'Log out';
  static const String logoutSubtitle = 'Sign out of admin';
}
