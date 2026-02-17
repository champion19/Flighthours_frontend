import 'package:flight_hours_app/core/services/session_service.dart';
import 'package:flight_hours_app/core/services/token_refresh_service.dart';
import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_event.dart';
import 'package:flight_hours_app/features/employee/presentation/bloc/employee_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelloEmployee extends StatefulWidget {
  const HelloEmployee({super.key});

  @override
  State<HelloEmployee> createState() => _HelloEmployeeState();
}

class _HelloEmployeeState extends State<HelloEmployee> {
  int _selectedIndex = 0;
  String _currentAirline = '';
  String _pilotName = 'Pilot';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadCurrentEmployee());
    context.read<EmployeeBloc>().add(LoadEmployeeAirlineRoutes());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    return BlocListener<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeDetailSuccess && state.response.data != null) {
          setState(() {
            final data = state.response.data!;
            _pilotName = data.name;
            _currentAirline = data.airline ?? '';
          });
        }
      },
      child: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        // Logbook - Navigate to logbook page
        _selectedIndex = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, '/logbook');
        });
        return _buildHomePage();
      case 2:
        return _buildSettingsPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildWelcomeCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              _pilotName.isNotEmpty ? _pilotName[0].toUpperCase() : 'P',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _pilotName,
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getGreeting(),
                style: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF6c757d),
            size: 26,
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.account_circle_outlined,
            color: Color(0xFF6c757d),
            size: 26,
          ),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            switch (value) {
              case 'profile':
                Navigator.pushNamed(context, '/employee-profile');
                break;
              case 'password':
                Navigator.pushNamed(context, '/change-password');
                break;
              case 'logout':
                TokenRefreshService().stopTokenRefreshCycle();
                await SessionService().clearSession();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
                break;
            }
          },
          itemBuilder:
              (context) => [
                _buildPopupMenuItem(
                  value: 'profile',
                  icon: Icons.person_outline,
                  title: 'My Profile',
                ),
                _buildPopupMenuItem(
                  value: 'password',
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                ),
                const PopupMenuDivider(),
                _buildPopupMenuItem(
                  value: 'logout',
                  icon: Icons.logout,
                  title: 'Log Out',
                  color: const Color(0xFFe17055),
                ),
              ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String title,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color ?? const Color(0xFF1a1a2e), size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: color ?? const Color(0xFF1a1a2e),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4facfe).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentAirline.isNotEmpty
                      ? 'Flying with $_currentAirline'
                      : 'Ready for your next flight',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== ROUTES PAGE ====================
  Widget _buildRoutesPage() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeAirlineRoutesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4facfe)),
          );
        }

        List<AirlineRouteEntity> allRoutes = [];

        if (state is EmployeeAirlineRoutesSuccess) {
          allRoutes = state.response.data;
        }

        // Filter routes by search query
        final filteredRoutes =
            _searchQuery.isEmpty
                ? allRoutes
                : allRoutes.where((route) {
                  final origin = (route.originAirportCode ?? '').toLowerCase();
                  final dest =
                      (route.destinationAirportCode ?? '').toLowerCase();
                  final airlineName = (route.airlineName ?? '').toLowerCase();
                  final routeName = (route.routeName ?? '').toLowerCase();
                  final query = _searchQuery.toLowerCase();
                  return origin.contains(query) ||
                      dest.contains(query) ||
                      airlineName.contains(query) ||
                      routeName.contains(query);
                }).toList();

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'My Routes',
                        style: TextStyle(
                          color: Color(0xFF1a1a2e),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${filteredRoutes.length} routes',
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search routes...',
                        hintStyle: const TextStyle(color: Color(0xFF6c757d)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF6c757d),
                        ),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF6c757d),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Routes list
            Expanded(
              child:
                  filteredRoutes.isEmpty
                      ? _buildEmptyRoutesState()
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredRoutes.length,
                        itemBuilder: (context, index) {
                          return _buildRouteCard(filteredRoutes[index]);
                        },
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyRoutesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.flight, color: Color(0xFF6c757d), size: 64),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No routes matching "$_searchQuery"'
                : (_currentAirline.isNotEmpty
                    ? 'No routes found for $_currentAirline'
                    : 'No airline assigned'),
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Text('Clear search'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(AirlineRouteEntity airlineRoute) {
    // Get route details
    String originCode = airlineRoute.originAirportCode ?? '???';
    String destCode = airlineRoute.destinationAirportCode ?? '???';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFe0e0e0)),
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
          // Route icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4facfe).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flight, color: Color(0xFF4facfe), size: 24),
          ),
          const SizedBox(width: 16),

          // Route info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$originCode → $destCode',
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  airlineRoute.airlineName ?? 'Unknown Airline',
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  airlineRoute.isActive
                      ? const Color(0xFF00b894).withValues(alpha: 0.1)
                      : const Color(0xFFe17055).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              airlineRoute.displayStatus,
              style: TextStyle(
                color:
                    airlineRoute.isActive
                        ? const Color(0xFF00b894)
                        : const Color(0xFFe17055),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SETTINGS PAGE ====================
  Widget _buildSettingsPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.settings_outlined,
            color: Color(0xFF6c757d),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Settings',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Coming soon...',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM NAV BAR ====================
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.book_outlined,
                activeIcon: Icons.book,
                label: 'Logbook',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: 'Settings',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color:
                isSelected ? const Color(0xFF4facfe) : const Color(0xFF6c757d),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color(0xFF4facfe)
                      : const Color(0xFF6c757d),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
