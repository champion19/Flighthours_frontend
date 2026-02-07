import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_bloc.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_event.dart';
import 'package:flight_hours_app/features/route/presentation/bloc/route_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page displaying all available flight routes
/// Based on the design showing route cards with origin/destination,
/// countries, flight time, and route type (International/National)
class FlightRoutesPage extends StatefulWidget {
  const FlightRoutesPage({super.key});

  @override
  State<FlightRoutesPage> createState() => _FlightRoutesPageState();
}

class _FlightRoutesPageState extends State<FlightRoutesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<RouteEntity> _filteredRoutes = [];
  List<RouteEntity> _allRoutes = [];

  @override
  void initState() {
    super.initState();
    // Load routes when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteBloc>().add(FetchRoutes());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRoutes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRoutes = _allRoutes;
      } else {
        _filteredRoutes =
            _allRoutes.where((route) {
              final queryLower = query.toLowerCase();
              final originCode = (route.originAirportCode ?? '').toLowerCase();
              final destCode =
                  (route.destinationAirportCode ?? '').toLowerCase();
              final originName = (route.originAirportName ?? '').toLowerCase();
              final destName =
                  (route.destinationAirportName ?? '').toLowerCase();
              final originCountry = (route.originCountry ?? '').toLowerCase();
              final destCountry =
                  (route.destinationCountry ?? '').toLowerCase();

              return originCode.contains(queryLower) ||
                  destCode.contains(queryLower) ||
                  originName.contains(queryLower) ||
                  destName.contains(queryLower) ||
                  originCountry.contains(queryLower) ||
                  destCountry.contains(queryLower);
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildRoutesList()),
          ],
        ),
      ),
    );
  }

  /// Header with back button, title, and search icon
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4facfe).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF4facfe),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Flight Routes',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flight, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  /// Search bar for filtering routes
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: _filterRoutes,
        style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search by airport code, name or country...',
          hintStyle: const TextStyle(color: Color(0xFF6c757d)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4facfe)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF212529)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4facfe), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// Main routes list with BLoC builder
  Widget _buildRoutesList() {
    return BlocBuilder<RouteBloc, RouteState>(
      builder: (context, state) {
        if (state is RouteLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4facfe)),
                SizedBox(height: 16),
                Text(
                  'Loading routes...',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is RouteError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<RouteBloc>().add(FetchRoutes());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4facfe),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RouteSuccess) {
          // Update the full list when data arrives
          if (_allRoutes.isEmpty || _allRoutes.length != state.routes.length) {
            _allRoutes = state.routes;
            if (_filteredRoutes.isEmpty) {
              _filteredRoutes = _allRoutes;
            }
          }
        }

        if (_filteredRoutes.isEmpty && _allRoutes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_land, size: 64, color: Color(0xFF6c757d)),
                SizedBox(height: 16),
                Text(
                  'No routes available',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (_filteredRoutes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: Color(0xFF6c757d),
                ),
                const SizedBox(height: 16),
                Text(
                  'No routes match "${_searchController.text}"',
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _filteredRoutes.length,
          itemBuilder: (context, index) {
            final route = _filteredRoutes[index];
            return _buildRouteCard(route);
          },
        );
      },
    );
  }

  /// Individual route card matching the design
  Widget _buildRouteCard(RouteEntity route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4facfe).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Type badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildTypeBadge(route.isInternational)],
                ),
                const SizedBox(height: 12),

                // Airport codes with plane icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      route.originAirportCode ?? '???',
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.flight,
                        color: const Color(0xFF4facfe).withValues(alpha: 0.7),
                        size: 28,
                      ),
                    ),
                    Text(
                      route.destinationAirportCode ?? '???',
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Estimated flight time
                Text(
                  'Est. Flight Time: ${route.formattedFlightTime}',
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFe9ecef)),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // Return the selected route for use in other features
                    Navigator.of(context).pop(route);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      color: Color(0xFF4facfe),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFe9ecef)),
              Expanded(
                child: TextButton(
                  onPressed: () => _showRouteInfo(route),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'View Info',
                    style: TextStyle(
                      color: Color(0xFF4facfe),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Badge showing International or National route type
  Widget _buildTypeBadge(bool isInternational) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isInternational
                ? const Color(0xFF4facfe).withValues(alpha: 0.1)
                : const Color(0xFF28a745).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isInternational
                  ? const Color(0xFF4facfe)
                  : const Color(0xFF28a745),
        ),
      ),
      child: Text(
        isInternational ? 'International' : 'National',
        style: TextStyle(
          color:
              isInternational
                  ? const Color(0xFF4facfe)
                  : const Color(0xFF28a745),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Show detailed route information in a bottom sheet
  void _showRouteInfo(RouteEntity route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe9ecef),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route Details',
                            style: TextStyle(
                              color: Color(0xFF1a1a2e),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            route.displayId,
                            style: const TextStyle(
                              color: Color(0xFF6c757d),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTypeBadge(route.isInternational),
                  ],
                ),
                const SizedBox(height: 24),

                // Route visualization
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Origin
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              route.originAirportCode ?? '???',
                              style: const TextStyle(
                                color: Color(0xFF1a1a2e),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              route.originAirportName ?? 'Unknown Airport',
                              style: const TextStyle(
                                color: Color(0xFF6c757d),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              route.originCountry ?? 'Unknown',
                              style: const TextStyle(
                                color: Color(0xFF4facfe),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Flight icon and time
                      Column(
                        children: [
                          const Icon(
                            Icons.flight,
                            color: Color(0xFF4facfe),
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 2,
                            color: const Color(
                              0xFF4facfe,
                            ).withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            route.formattedFlightTime,
                            style: const TextStyle(
                              color: Color(0xFF6c757d),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      // Destination
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              route.destinationAirportCode ?? '???',
                              style: const TextStyle(
                                color: Color(0xFF1a1a2e),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              route.destinationAirportName ?? 'Unknown Airport',
                              style: const TextStyle(
                                color: Color(0xFF6c757d),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              route.destinationCountry ?? 'Unknown',
                              style: const TextStyle(
                                color: Color(0xFF4facfe),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Additional info rows
                _buildInfoRow(
                  'Route Type',
                  route.routeType ??
                      (route.isInternational ? 'Internacional' : 'Nacional'),
                ),
                _buildInfoRow(
                  'Estimated Flight Time',
                  route.formattedFlightTime,
                ),
                _buildInfoRow('Status', route.status ?? 'Active'),

                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4facfe),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  /// Info row for the bottom sheet
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
