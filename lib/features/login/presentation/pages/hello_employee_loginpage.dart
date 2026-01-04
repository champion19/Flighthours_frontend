import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flutter/material.dart';

class HelloEmployee extends StatelessWidget {
  const HelloEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildWelcomeCard(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Airline Management'),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        context,
                        icon: Icons.search,
                        title: 'Search Airline',
                        subtitle: 'Find airline information by ID',
                        gradientColors: [
                          const Color(0xFF4facfe),
                          const Color(0xFF00f2fe),
                        ],
                        onTap:
                            () =>
                                Navigator.pushNamed(context, '/airline-search'),
                      ),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        context,
                        icon: Icons.toggle_on,
                        title: 'Airline Status',
                        subtitle: 'Activate or deactivate airlines',
                        gradientColors: [
                          const Color(0xFFf093fb),
                          const Color(0xFFf5576c),
                        ],
                        onTap:
                            () =>
                                Navigator.pushNamed(context, '/airline-status'),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('My Account'),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        context,
                        icon: Icons.person,
                        title: 'My Profile',
                        subtitle: 'View and edit your information',
                        gradientColors: [
                          const Color(0xFF667eea),
                          const Color(0xFF764ba2),
                        ],
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/employee-profile',
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        context,
                        icon: Icons.lock_reset,
                        title: 'Change Password',
                        subtitle: 'Update your account security',
                        gradientColors: [
                          const Color(0xFFf093fb),
                          const Color(0xFFf5576c),
                        ],
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              '/change-password',
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Other Modules'),
                      const SizedBox(height: 12),
                      _buildMenuCard(
                        context,
                        icon: Icons.local_airport,
                        title: 'Airport Info',
                        subtitle: 'View airport details',
                        gradientColors: [
                          const Color(0xFFee0979),
                          const Color(0xFFff6a00),
                        ],
                        onTap: () => Navigator.pushNamed(context, '/airport'),
                      ),
                      const SizedBox(height: 40),
                      _buildLogoutButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4facfe).withValues(alpha: 0.8),
                  const Color(0xFF00f2fe).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flight Hours',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Employee Dashboard',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea).withValues(alpha: 0.8),
            const Color(0xFF764ba2).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.waving_hand, color: Colors.amber, size: 28),
              SizedBox(width: 12),
              Text(
                'Hey Employee!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Welcome to the Flight Hours management system. Select an option below to get started.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuCard(
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
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.3),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        // Clear all session data
        await SessionService().clearSession();
        // Navigate to AuthPage (root) which shows login/register options
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
      icon: const Icon(Icons.logout, color: Colors.white38, size: 20),
      label: const Text(
        'Log out',
        style: TextStyle(color: Colors.white38, fontSize: 14),
      ),
    );
  }
}
