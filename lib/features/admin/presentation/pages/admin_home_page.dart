import 'package:flight_hours_app/core/constants/admin_messages.dart';
import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeCard(),
                    const SizedBox(height: 24),

                    // Management Section
                    _buildSectionTitle(AdminMessages.routeManagement),
                    const SizedBox(height: 12),
                    _buildManagementCard(
                      context,
                      icon: Icons.flight,
                      title: AdminMessages.airlinesTitle,
                      subtitle: AdminMessages.airlinesSubtitle,
                      gradientColors: [
                        const Color(0xFF4facfe),
                        const Color(0xFF00f2fe),
                      ],
                      onTap: () {
                        Navigator.pushNamed(context, '/airlines');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildManagementCard(
                      context,
                      icon: Icons.route,
                      title: AdminMessages.routesTitle,
                      subtitle: AdminMessages.routesSubtitle,
                      gradientColors: [
                        const Color(0xFF11998e),
                        const Color(0xFF38ef7d),
                      ],
                      onTap: () {
                        Navigator.pushNamed(context, '/flight-routes');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildManagementCard(
                      context,
                      icon: Icons.alt_route,
                      title: AdminMessages.airlineRoutesTitle,
                      subtitle: AdminMessages.airlineRoutesSubtitle,
                      gradientColors: [
                        const Color(0xFFf093fb),
                        const Color(0xFFf5576c),
                      ],
                      onTap: () {
                        Navigator.pushNamed(context, '/airline-routes');
                      },
                    ),
                    const SizedBox(height: 24),

                    // System Section
                    _buildSectionTitle(AdminMessages.systemConfiguration),
                    const SizedBox(height: 12),
                    _buildSecondaryCard(
                      context,
                      icon: Icons.local_airport,
                      title: AdminMessages.airportsTitle,
                      color: const Color(0xFFf093fb),
                      onTap: () {
                        Navigator.pushNamed(context, '/airports');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSecondaryCard(
                      context,
                      icon: Icons.airplanemode_active,
                      title: AdminMessages.aircraftModelsTitle,
                      color: const Color(0xFF667eea),
                      onTap: () {
                        Navigator.pushNamed(context, '/aircraft-models');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSecondaryCard(
                      context,
                      icon: Icons.flight_takeoff,
                      title: AdminMessages.aircraftFamiliesTitle,
                      color: const Color(0xFF764ba2),
                      onTap: () {
                        Navigator.pushNamed(context, '/aircraft-families');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSecondaryCard(
                      context,
                      icon: Icons.precision_manufacturing,
                      title: 'Manufacturers',
                      color: const Color(0xFFf5576c),
                      onTap: () {
                        Navigator.pushNamed(context, '/manufacturers');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSecondaryCard(
                      context,
                      icon: Icons.settings,
                      title: AdminMessages.systemSettingsTitle,
                      color: const Color(0xFF6c757d),
                      onTap: () {
                        _showComingSoon(context, 'System Settings');
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
      ),
      child: Row(
        children: [
          // Admin badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AdminMessages.panelTitle,
                style: const TextStyle(
                  color: Color(0xFF262626),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AdminMessages.panelSubtitle,
                style: const TextStyle(color: Color(0xFF6c757d), fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await SessionService().clearSession();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFf8f9fa),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFe17055).withValues(alpha: 0.3),
            ),
          ),
          child: const Icon(Icons.logout, color: Color(0xFFe17055), size: 24),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AdminMessages.welcomeTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF6c757d),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFe9ecef)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: const Color(0xFF667eea),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
