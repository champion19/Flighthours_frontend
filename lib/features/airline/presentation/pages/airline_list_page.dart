import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirlineListPage extends StatefulWidget {
  const AirlineListPage({super.key});

  @override
  State<AirlineListPage> createState() => _AirlineListPageState();
}

class _AirlineListPageState extends State<AirlineListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AirlineBloc>().add(FetchAirlines());
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
    context.read<AirlineBloc>().add(FetchAirlines());
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
          'Airlines',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1a1a2e)),
      ),
      body: BlocConsumer<AirlineBloc, AirlineState>(
        listener: (context, state) {
          if (state is AirlineStatusUpdateSuccess) {
            _showStatusUpdateResult(context, state.message, true);
          } else if (state is AirlineStatusUpdateError) {
            _showStatusUpdateResult(context, state.message, false);
          }
        },
        builder: (context, state) {
          if (state is AirlineLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF4facfe)),
            );
          } else if (state is AirlineSuccess) {
            return _buildAirlineList(state.airlines);
          } else if (state is AirlineError) {
            return _buildErrorState(state.message);
          } else if (state is AirlineStatusUpdating) {
            // Show loading while updating status
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF4facfe)),
                  SizedBox(height: 16),
                  Text(
                    'Updating status...',
                    style: TextStyle(color: Color(0xFF6c757d)),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No airlines found.',
                style: TextStyle(color: Color(0xFF6c757d)),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAirlineList(List<AirlineEntity> airlines) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AirlineBloc>().add(FetchAirlines());
      },
      color: const Color(0xFF4facfe),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: airlines.length,
        itemBuilder: (context, index) {
          final airline = airlines[index];
          return _buildAirlineCard(airline);
        },
      ),
    );
  }

  Widget _buildAirlineCard(AirlineEntity airline) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF212529)),
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
            // Airline icon
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
            const SizedBox(width: 16),
            // Airline info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airline.name,
                    style: const TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (airline.code != null && airline.code!.isNotEmpty)
                    Text(
                      'Code: ${airline.code}',
                      style: const TextStyle(
                        color: Color(0xFF6c757d),
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    'ID: ${airline.id}',
                    style: const TextStyle(
                      color: Color(0xFF6c757d),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Activate button
                IconButton(
                  onPressed: () => _showActivateConfirmation(airline),
                  icon: const Icon(Icons.check_circle_outline),
                  color: const Color(0xFF00b894),
                  tooltip: 'Activate',
                ),
                // Deactivate button
                IconButton(
                  onPressed: () => _showDeactivateConfirmation(airline),
                  icon: const Icon(Icons.cancel_outlined),
                  color: Colors.redAccent,
                  tooltip: 'Deactivate',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showActivateConfirmation(AirlineEntity airline) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Activate Airline',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to activate "${airline.name}"?',
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
                  context.read<AirlineBloc>().add(
                    ActivateAirline(airlineId: airline.id),
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

  void _showDeactivateConfirmation(AirlineEntity airline) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Deactivate Airline',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to deactivate "${airline.name}"?',
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
                  context.read<AirlineBloc>().add(
                    DeactivateAirline(airlineId: airline.id),
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
            onPressed: () {
              context.read<AirlineBloc>().add(FetchAirlines());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4facfe),
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
