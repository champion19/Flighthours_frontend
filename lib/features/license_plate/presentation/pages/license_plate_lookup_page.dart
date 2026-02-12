import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/license_plate/domain/entities/license_plate_entity.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_bloc.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_event.dart';
import 'package:flight_hours_app/features/license_plate/presentation/bloc/license_plate_state.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_bloc.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_event.dart';
import 'package:flight_hours_app/features/flight/presentation/bloc/flight_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LicensePlateLookupPage extends StatefulWidget {
  const LicensePlateLookupPage({super.key});

  @override
  State<LicensePlateLookupPage> createState() => _LicensePlateLookupPageState();
}

class _LicensePlateLookupPageState extends State<LicensePlateLookupPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<LicensePlateBloc>().state;
    if (state is LicensePlateSuccess) {
      _controller.text = state.licensePlate.licensePlate;
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
      context.read<LicensePlateBloc>().add(SearchLicensePlate(query));
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
          'License Plate',
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
            _showSuccessDialog();
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
                  child: BlocBuilder<LicensePlateBloc, LicensePlateState>(
                    builder: (context, state) {
                      if (state is LicensePlateLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4facfe),
                            strokeWidth: 2.5,
                          ),
                        );
                      }
                      if (state is LicensePlateError) {
                        return _buildError(state.message);
                      }
                      if (state is LicensePlateSuccess) {
                        return _buildResult(
                          state.licensePlate,
                          state.aircraftModel,
                        );
                      }
                      return _buildHint();
                    },
                  ),
                ),

                // ── Guardar Vuelo button ──
                BlocBuilder<LicensePlateBloc, LicensePlateState>(
                  builder: (context, state) {
                    if (state is LicensePlateSuccess) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _isSaving
                                    ? null
                                    : () => _onSaveFlight(state.licensePlate),
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
                                              'Guardar Vuelo',
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
    return Center(
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
              'Enter the license plate number\nto look up aircraft info',
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

  Widget _buildResult(LicensePlateEntity lp, AircraftModelEntity? am) {
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
                  lp.licensePlate,
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
                  lp.modelName,
                  true,
                ),
                _buildRow(Icons.airlines, 'Airline', lp.airlineName, false),
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

  void _onSaveFlight(LicensePlateEntity licensePlate) {
    // Get flight data passed from NewFlightPage (Step 1)
    final flightData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    debugPrint('🛫 _onSaveFlight: flightData from args = $flightData');
    debugPrint('🛫 _onSaveFlight: licensePlate.id = ${licensePlate.id}');

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

    // Build payload for POST /daily-logbooks/:id/details
    // 4 fields: flight info + airline route + license plate
    final completeData = <String, dynamic>{
      'flight_real_date': flightData['flight_real_date'],
      'flight_number': flightData['flight_number'],
      'airline_route_id': flightData['airline_route_id'],
      'license_plate_id': licensePlate.id,
    };

    // Extract logbook ID (it's not part of the POST body)
    // Extract logbook ID from step 1 data
    final logbookId = (flightData['daily_logbook_id'] as String?) ?? '';

    debugPrint('🛫 _onSaveFlight: logbookId = "$logbookId"');
    debugPrint('🛫 _onSaveFlight: completeData = $completeData');

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

    // Fire CreateFlight event → POST /daily-logbooks/:logbookId/details
    context.read<FlightBloc>().add(
      CreateFlight(dailyLogbookId: logbookId, data: completeData),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00b894).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00b894),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Vuelo Guardado!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1a2e),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'La información del vuelo ha sido registrada exitosamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // close dialog
                    Navigator.of(context).pop(); // back to NewFlightPage
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00b894),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
