import 'package:flight_hours_app/features/airline_route/domain/entities/airline_route_entity.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_bloc.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_event.dart';
import 'package:flight_hours_app/features/airline_route/presentation/bloc/airline_route_state.dart';
import 'package:flight_hours_app/features/route/domain/entities/route_entity.dart';
import 'package:flight_hours_app/features/route/domain/usecases/get_route_by_id_use_case.dart';
import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page displaying all airline routes
/// Based on the design showing route cards with AR code, route display,
/// airline name, status badge, and View/Edit buttons
class AirlineRoutesPage extends StatefulWidget {
  const AirlineRoutesPage({super.key});

  @override
  State<AirlineRoutesPage> createState() => _AirlineRoutesPageState();
}

class _AirlineRoutesPageState extends State<AirlineRoutesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AirlineRouteEntity> _filteredAirlineRoutes = [];
  List<AirlineRouteEntity> _allAirlineRoutes = [];

  @override
  void initState() {
    super.initState();
    // Load airline routes when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AirlineRouteBloc>().add(FetchAirlineRoutes());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Apply filter logic without setState (for use inside existing setState)
  void _applyFilter(String query) {
    if (query.isEmpty) {
      _filteredAirlineRoutes = _allAirlineRoutes;
    } else {
      _filteredAirlineRoutes =
          _allAirlineRoutes.where((airlineRoute) {
            final queryLower = query.toLowerCase();
            final displayId = airlineRoute.displayId.toLowerCase();
            final originalId = airlineRoute.id.toLowerCase();
            final routeDisplay = airlineRoute.routeDisplay.toLowerCase();
            final airlineName = (airlineRoute.airlineName ?? '').toLowerCase();

            return displayId.contains(queryLower) ||
                originalId.contains(queryLower) ||
                routeDisplay.contains(queryLower) ||
                airlineName.contains(queryLower);
          }).toList();
    }
  }

  void _filterAirlineRoutes(String query) {
    setState(() {
      _applyFilter(query);
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
            _buildAddButton(),
            _buildSearchBar(),
            Expanded(child: _buildAirlineRoutesList()),
          ],
        ),
      ),
    );
  }

  /// Header with back button and title
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
              'Airline Routes',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 56), // Balance the back button
        ],
      ),
    );
  }

  /// Add New Airline Route button
  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Navigate to add new airline route page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add New Airline Route - Coming soon'),
                backgroundColor: Color(0xFF4facfe),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a3a6e),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add New Airline Route',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  /// Search bar for filtering airline routes
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: _filterAirlineRoutes,
        style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search routes by ID, airline...',
          hintStyle: const TextStyle(color: Color(0xFF6c757d)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6c757d)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFe9ecef)),
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

  void _showStatusUpdateResult(
    BuildContext context,
    String message,
    bool isSuccess,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? const Color(0xFF00b894) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // Refresh the list after status update
    context.read<AirlineRouteBloc>().add(FetchAirlineRoutes());
  }

  /// Main airline routes list with BLoC consumer
  Widget _buildAirlineRoutesList() {
    return BlocConsumer<AirlineRouteBloc, AirlineRouteState>(
      listener: (context, state) {
        if (state is AirlineRouteStatusUpdateSuccess) {
          _showStatusUpdateResult(context, state.message, true);
        } else if (state is AirlineRouteStatusUpdateError) {
          _showStatusUpdateResult(context, state.message, false);
        } else if (state is AirlineRouteSuccess) {
          // Update lists after build completes to avoid setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _allAirlineRoutes = state.airlineRoutes;
                if (_searchController.text.isNotEmpty) {
                  _applyFilter(_searchController.text);
                } else {
                  _filteredAirlineRoutes = _allAirlineRoutes;
                }
              });
            }
          });
        }
      },
      builder: (context, state) {
        if (state is AirlineRouteLoading ||
            state is AirlineRouteStatusUpdating) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4facfe)),
                SizedBox(height: 16),
                Text(
                  'Loading airline routes...',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is AirlineRouteError) {
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
                    context.read<AirlineRouteBloc>().add(FetchAirlineRoutes());
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

        if (_filteredAirlineRoutes.isEmpty && _allAirlineRoutes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_land, size: 64, color: Color(0xFF6c757d)),
                SizedBox(height: 16),
                Text(
                  'No airline routes available',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (_filteredAirlineRoutes.isEmpty) {
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
          itemCount: _filteredAirlineRoutes.length,
          itemBuilder: (context, index) {
            final airlineRoute = _filteredAirlineRoutes[index];
            return _buildAirlineRouteCard(airlineRoute);
          },
        );
      },
    );
  }

  /// Individual airline route card matching the design
  Widget _buildAirlineRouteCard(AirlineRouteEntity airlineRoute) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route display and status badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      airlineRoute.routeDisplay,
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    _buildStatusBadge(airlineRoute),
                  ],
                ),
                const SizedBox(height: 4),

                // Airline name
                Text(
                  airlineRoute.airlineName ?? 'Unknown Airline',
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

          // Action buttons row 1: View and Status
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _viewRouteDetails(airlineRoute),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Color(0xFF6c757d),
                  ),
                  label: const Text(
                    'View',
                    style: TextStyle(
                      color: Color(0xFF6c757d),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFe9ecef)),
              // Activate button
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showActivateConfirmation(airlineRoute),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Color(0xFF00b894),
                  ),
                  label: const Text(
                    'Activate',
                    style: TextStyle(
                      color: Color(0xFF00b894),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFe9ecef)),
              // Deactivate button
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showDeactivateConfirmation(airlineRoute),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Deactivate',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show activate confirmation dialog
  void _showActivateConfirmation(AirlineRouteEntity airlineRoute) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Activate Airline Route',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to activate "${airlineRoute.routeDisplay}"?',
              style: const TextStyle(color: Color(0xFF6c757d)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6c757d)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AirlineRouteBloc>().add(
                    ActivateAirlineRoute(airlineRouteId: airlineRoute.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00b894),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Activate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  /// Show deactivate confirmation dialog
  void _showDeactivateConfirmation(AirlineRouteEntity airlineRoute) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Deactivate Airline Route',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to deactivate "${airlineRoute.routeDisplay}"?',
              style: const TextStyle(color: Color(0xFF6c757d)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6c757d)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AirlineRouteBloc>().add(
                    DeactivateAirlineRoute(airlineRouteId: airlineRoute.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Deactivate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  /// Status badge with appropriate color
  Widget _buildStatusBadge(AirlineRouteEntity airlineRoute) {
    Color badgeColor;
    Color textColor;

    if (airlineRoute.isActive) {
      badgeColor = const Color(0xFF28a745).withValues(alpha: 0.1);
      textColor = const Color(0xFF28a745);
    } else if (airlineRoute.isPending) {
      badgeColor = const Color(0xFFffc107).withValues(alpha: 0.1);
      textColor = const Color(0xFFe6a800);
    } else {
      badgeColor = const Color(0xFF6c757d).withValues(alpha: 0.1);
      textColor = const Color(0xFF6c757d);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        airlineRoute.displayStatus,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// View route details by calling the route feature
  Future<void> _viewRouteDetails(AirlineRouteEntity airlineRoute) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFF4facfe)),
          ),
    );

    try {
      // Call the route feature to get route details using the routeId
      final getRouteByIdUseCase = InjectorApp.resolve<GetRouteByIdUseCase>();
      final route = await getRouteByIdUseCase.call(airlineRoute.routeId);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (route != null) {
        // Show route details in a bottom sheet
        if (mounted) _showRouteDetailsBottomSheet(route, airlineRoute);
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Route details not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading route: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show route details in a bottom sheet
  void _showRouteDetailsBottomSheet(
    RouteEntity route,
    AirlineRouteEntity airlineRoute,
  ) {
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

                // Title with airline info
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
                            airlineRoute.airlineName ?? 'Unknown Airline',
                            style: const TextStyle(
                              color: Color(0xFF6c757d),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(airlineRoute),
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
