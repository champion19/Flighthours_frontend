import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirportListPage extends StatefulWidget {
  const AirportListPage({super.key});

  @override
  State<AirportListPage> createState() => _AirportListPageState();
}

class _AirportListPageState extends State<AirportListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AirportBloc>().add(FetchAirports());
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
    context.read<AirportBloc>().add(FetchAirports());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Airports',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1a1a2e)),
      ),
      body: BlocConsumer<AirportBloc, AirportState>(
        listener: (context, state) {
          if (state is AirportStatusUpdateSuccess) {
            _showStatusUpdateResult(
              context,
              'Airport ${state.isActivation ? "activated" : "deactivated"} successfully',
              true,
            );
          } else if (state is AirportError) {
            _showStatusUpdateResult(context, state.message, false);
          }
        },
        builder: (context, state) {
          if (state is AirportLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFf093fb)),
            );
          } else if (state is AirportSuccess) {
            return _buildAirportList(state.airports);
          } else if (state is AirportError) {
            return _buildErrorState(state.message);
          } else {
            return const Center(
              child: Text(
                'No airports found.',
                style: TextStyle(color: Color(0xFF6c757d)),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAirportList(List<AirportEntity> airports) {
    return RefreshIndicator(
      onRefresh: () async => context.read<AirportBloc>().add(FetchAirports()),
      color: const Color(0xFFf093fb),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: airports.length,
        itemBuilder: (context, index) => _buildAirportCard(airports[index]),
      ),
    );
  }

  Widget _buildAirportCard(AirportEntity airport) {
    final isActive = airport.status == 'active' || airport.status == '1';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF212529) : const Color(0xFFdee2e6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isActive
                          ? [const Color(0xFFf093fb), const Color(0xFFf5576c)]
                          : [const Color(0xFFadb5bd), const Color(0xFFced4da)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_airport,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          airport.name,
                          style: TextStyle(
                            color:
                                isActive
                                    ? const Color(0xFF1a1a2e)
                                    : const Color(0xFF6c757d),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? const Color(
                                    0xFF00b894,
                                  ).withValues(alpha: 0.1)
                                  : const Color(
                                    0xFFe17055,
                                  ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color:
                                isActive
                                    ? const Color(0xFF00b894)
                                    : const Color(0xFFe17055),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      if (airport.iataCode != null &&
                          airport.iataCode!.isNotEmpty)
                        _buildChip(airport.iataCode!, Icons.flight),
                      if (airport.city != null && airport.city!.isNotEmpty)
                        _buildChip(airport.city!, Icons.location_city),
                      if (airport.country != null &&
                          airport.country!.isNotEmpty)
                        _buildChip(airport.country!, Icons.flag),
                    ],
                  ),
                  if (airport.airportType != null &&
                      airport.airportType!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        airport.airportType!,
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildToggleButton(airport, isActive),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6c757d)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(AirportEntity airport, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            () =>
                isActive
                    ? _showDeactivateConfirmation(airport)
                    : _showActivateConfirmation(airport),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                isActive
                    ? const Color(0xFFe17055).withValues(alpha: 0.1)
                    : const Color(0xFF00b894).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isActive
                      ? const Color(0xFFe17055).withValues(alpha: 0.3)
                      : const Color(0xFF00b894).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.cancel_outlined : Icons.check_circle_outline,
                color:
                    isActive
                        ? const Color(0xFFe17055)
                        : const Color(0xFF00b894),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isActive ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color:
                      isActive
                          ? const Color(0xFFe17055)
                          : const Color(0xFF00b894),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActivateConfirmation(AirportEntity airport) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Activate Airport',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to activate "${airport.name}"?',
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
                  context.read<AirportBloc>().add(
                    ActivateAirport(airportId: airport.id),
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

  void _showDeactivateConfirmation(AirportEntity airport) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Deactivate Airport',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to deactivate "${airport.name}"?',
                  style: const TextStyle(color: Color(0xFF6c757d)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffeaa7).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFfdcb6e)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Color(0xFFe17055),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This airport will not be available for routes.',
                          style: TextStyle(
                            color: Color(0xFF1a1a2e),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  context.read<AirportBloc>().add(
                    DeactivateAirport(airportId: airport.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe17055),
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Color(0xFF6c757d)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AirportBloc>().add(FetchAirports()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf093fb),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
