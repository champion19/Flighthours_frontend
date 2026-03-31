import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/flight/domain/entities/flight_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/tail_number/domain/entities/tail_number_entity.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_bloc.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_event.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_state.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TailNumberLookupPage extends StatefulWidget {
  const TailNumberLookupPage({super.key});

  @override
  State<TailNumberLookupPage> createState() => _TailNumberLookupPageState();
}

class _TailNumberLookupPageState extends State<TailNumberLookupPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<TailNumberBloc>().state;
    if (state is TailNumberSuccess) {
      _controller.text = state.tailNumber.tailNumber;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<TailNumberBloc>().add(SearchTailNumber(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1a1a2e)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tail Number',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<FlightBloc, FlightState>(
        listener: (context, state) {
          if (state is FlightCreated) {
            setState(() => _isSaving = false);
            _navigateToDetail(state.flight);
          } else if (state is FlightError) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFe17055),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // ── Search bar ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            // Only allow letters (A-Z, a-z) and hyphens
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z\-]'),
                            ),
                            // Force uppercase
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.toUpperCase(),
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1a1a2e),
                          ),
                          decoration: const InputDecoration(
                            hintText: 'e.g. CC-BAC',
                            hintStyle: TextStyle(
                              color: Color(0xFFadb5bd),
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.airplane_ticket_outlined,
                              color: Color(0xFF4facfe),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: _search,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Result / Hint area ──
                Expanded(
                  child: BlocBuilder<TailNumberBloc, TailNumberState>(
                    builder: (context, state) {
                      if (state is TailNumberLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4facfe),
                            strokeWidth: 2.5,
                          ),
                        );
                      }
                      if (state is TailNumberError) {
                        return _buildError(state.message);
                      }
                      if (state is TailNumberSuccess) {
                        return _buildResult(
                          state.tailNumber,
                          state.aircraftModel,
                        );
                      }
                      return _buildHint();
                    },
                  ),
                ),

                // ── Save Flight button ──
                BlocBuilder<TailNumberBloc, TailNumberState>(
                  builder: (context, state) {
                    if (state is TailNumberSuccess) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _isSaving
                                    ? null
                                    : () => _onSaveFlight(state.tailNumber),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient:
                                    _isSaving
                                        ? null
                                        : const LinearGradient(
                                          colors: [
                                            Color(0xFF4facfe),
                                            Color(0xFF00f2fe),
                                          ],
                                        ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child:
                                    _isSaving
                                        ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.save,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Save Flight',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Widgets
  // ────────────────────────────────────────────────

  Widget _buildHint() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.airplane_ticket_outlined,
                color: const Color(0xFF4facfe).withValues(alpha: 0.6),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Search Aircraft Registration',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the tail number\nto look up aircraft info',
              style: TextStyle(
                color: Color(0xFF6c757d),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(TailNumberEntity tn, AircraftModelEntity? am) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4facfe).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flight, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  tn.tailNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Info Card ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildRow(
                  Icons.airplanemode_active,
                  'Aircraft Model',
                  tn.modelName,
                  true,
                ),
                _buildRow(Icons.airlines, 'Airline', tn.airlineName, false),
                if (am != null) ...[
                  _buildRow(
                    Icons.category,
                    'Aircraft Type',
                    am.aircraftTypeName,
                    false,
                  ),
                  _buildRow(Icons.settings, 'Engine', am.engineName, false),
                  _buildRow(Icons.toggle_on, 'Status', am.status, false),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String? value, bool isFirst) {
    return Column(
      children: [
        if (!isFirst)
          Divider(
            height: 1,
            color: const Color(0xFFe0e0e0).withValues(alpha: 0.6),
            indent: 56,
            endIndent: 20,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF4facfe), size: 20),
              ),
              const SizedBox(width: 14),
              // Label + Value centered vertically
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF6c757d),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value ?? 'N/A',
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFe17055).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFe17055),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFF495057),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Flight Save Logic
  // ────────────────────────────────────────────────

  void _onSaveFlight(TailNumberEntity tailNumber) {
    // Get flight data passed from NewFlightPage (Step 1)
    final flightData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    debugPrint('🛫 _onSaveFlight: flightData from args = $flightData');
    debugPrint('🛫 _onSaveFlight: tailNumber.id = ${tailNumber.id}');

    if (flightData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No flight data found. Please go back and try again.',
          ),
          backgroundColor: const Color(0xFFe17055),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final logbookId = (flightData['daily_logbook_id'] as String?) ?? '';
    final detailId = flightData['detail_id'] as String?;

    debugPrint('🛫 _onSaveFlight: logbookId = "$logbookId"');
    debugPrint('🛫 _onSaveFlight: detailId = "$detailId"');

    if (logbookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not determine logbook. Please try again.'),
          backgroundColor: const Color(0xFFe17055),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    if (detailId != null && detailId.isNotEmpty) {
      // ── EDIT MODE: Just pop back with the data ──
      // DailyLogbookDetailPage will do the actual PUT with all 16 fields
      Navigator.of(context).pop({
        'detail_id': detailId,
        'tail_number_id': tailNumber.id,
        'tail_number_name': tailNumber.tailNumber,
        'flight_real_date': flightData['flight_real_date'],
        'flight_number': flightData['flight_number'],
        'airline_route_id': flightData['airline_route_id'],
        'daily_logbook_id': logbookId,
      });
    } else {
      // ── CREATE MODE: POST /daily-logbooks/:logbookId/details ──
      final completeData = <String, dynamic>{
        'flight_real_date': flightData['flight_real_date'],
        'flight_number': flightData['flight_number'],
        'airline_route_id': flightData['airline_route_id'],
        'tail_number_id': tailNumber.id,
      };

      context.read<FlightBloc>().add(
        CreateFlight(dailyLogbookId: logbookId, data: completeData),
      );
    }
  }

  /// After successful flight creation, navigate to the detail form
  /// so the user can fill in times, pilot role, etc.
  void _navigateToDetail(FlightEntity? flight) {
    if (flight == null) {
      // Fallback: pop back if no flight data returned
      Navigator.of(context).pop();
      return;
    }

    // Convert FlightEntity → LogbookDetailEntity for the detail form
    final detail = LogbookDetailEntity(
      id: flight.id,
      dailyLogbookId: flight.dailyLogbookId,
      flightNumber: flight.flightNumber,
      flightRealDate: flight.flightRealDate,
      airlineRouteId: flight.airlineRouteId,
      routeCode: flight.routeCode,
      originIataCode: flight.originIataCode,
      destinationIataCode: flight.destinationIataCode,
      airlineCode: flight.airlineCode,
      tailNumberId: flight.tailNumberId,
      tailNumber: flight.tailNumber,
      modelName: flight.modelName,
      outTime: flight.outTime,
      takeoffTime: flight.takeoffTime,
      landingTime: flight.landingTime,
      inTime: flight.inTime,
      airTime: flight.airTime,
      blockTime: flight.blockTime,
      dutyTime: flight.dutyTime,
      pilotRole: flight.pilotRole,
      companionName: flight.companionName,
      passengers: flight.passengers,
      approachType: flight.approachType,
      flightType: flight.flightType,
    );

    // Replace the current navigation stack:
    // Pop TailNumber + NewFlight pages, then push the detail form
    Navigator.of(context).popUntil(
      (route) =>
          route.isFirst || route.settings.name == '/daily-logbook-detail',
    );
    Navigator.of(
      context,
    ).pushNamed('/daily-logbook-detail-form', arguments: {'detail': detail});
  }
}
