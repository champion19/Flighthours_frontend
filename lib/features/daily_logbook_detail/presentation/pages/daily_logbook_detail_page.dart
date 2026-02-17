import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Detail page for a daily logbook entry.
/// Shows flight summary, input fields, role selectors, and calculated times.
/// Supports "edit mode" when a LogbookDetailEntity is passed in the route args.
class DailyLogbookDetailPage extends StatefulWidget {
  const DailyLogbookDetailPage({super.key});

  @override
  State<DailyLogbookDetailPage> createState() => _DailyLogbookDetailPageState();
}

class _DailyLogbookDetailPageState extends State<DailyLogbookDetailPage> {
  // Input controllers
  final _paxController = TextEditingController();
  final _inController = TextEditingController();
  final _onController = TextEditingController();
  final _outController = TextEditingController();
  final _offController = TextEditingController();

  // Dropdown selections
  String? _selectedCrewRole; // Captain / Copilot
  String? _selectedPilotRole; // PF / PNF / PFL / PFTO

  final List<String> _crewRoles = ['Captain', 'Copilot'];
  final List<String> _pilotRoles = ['PF', 'PNF', 'PFL', 'PFTO'];

  // Route arguments
  DailyLogbookEntity? _logbook;
  LogbookDetailEntity? _detail;
  bool _isEditMode = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _parseArguments();
    }
  }

  void _parseArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic>) {
      // New format: Map with logbook + optional detail
      _logbook = args['logbook'] as DailyLogbookEntity?;
      _detail = args['detail'] as LogbookDetailEntity?;
    } else if (args is DailyLogbookEntity) {
      // Legacy format: just a logbook entity
      _logbook = args;
    }

    _isEditMode = _detail != null;

    if (_isEditMode) {
      _prefillFields();
    }
  }

  void _prefillFields() {
    final d = _detail!;
    _paxController.text = d.passengers?.toString() ?? '';
    _outController.text = _formatTimeForField(d.outTime);
    _offController.text = _formatTimeForField(d.takeoffTime);
    _onController.text = _formatTimeForField(d.landingTime);
    _inController.text = _formatTimeForField(d.inTime);

    // Map pilot role
    if (d.pilotRole != null &&
        _pilotRoles.contains(d.pilotRole!.toUpperCase())) {
      _selectedPilotRole = d.pilotRole!.toUpperCase();
    }

    // Map crew role — backend sends 'captain'/'copilot', dropdown expects 'Captain'/'Copilot'
    if (d.companionName != null || d.pilotRole != null) {
      // We don't have a crew_role in the entity currently,
      // default to Captain for now
      _selectedCrewRole = 'Captain';
    }
  }

  /// Format HH:MM:SS to HH:MM for time fields
  String _formatTimeForField(String? time) {
    if (time == null || time.isEmpty) return '';
    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }

  /// Format HH:MM to HH:MM:SS for API
  String _formatTimeForApi(String time) {
    if (time.isEmpty) return '00:00:00';
    final parts = time.split(':');
    if (parts.length == 2) return '$time:00';
    return time;
  }

  @override
  void dispose() {
    _paxController.dispose();
    _inController.dispose();
    _onController.dispose();
    _outController.dispose();
    _offController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogbookBloc, LogbookState>(
      listener: (context, state) {
        if (state is LogbookDetailUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(state.message),
                ],
              ),
              backgroundColor: const Color(0xFF28a745),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context, true); // Return true to signal update
        } else if (state is LogbookError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF4facfe),
              size: 22,
            ),
          ),
          title: Column(
            children: [
              Text(
                _isEditMode ? 'Daily Logbook Detail' : 'Detail',
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_logbook != null)
                Text(
                  _logbook!.fullFormattedDate,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Action Buttons ──
              _buildActionButtons(),
              const SizedBox(height: 20),

              // ── Flight Summary Card ──
              _buildSectionLabel('Flight Information'),
              const SizedBox(height: 8),
              _buildFlightSummaryCard(),
              const SizedBox(height: 24),

              // ── PAX, In, On, Out, Off inputs ──
              _buildSectionLabel('Times & Passengers'),
              const SizedBox(height: 8),
              _buildPaxTimesInputs(),
              const SizedBox(height: 24),

              // ── Captain / Copilot select ──
              _buildSectionLabel('Crew Role'),
              const SizedBox(height: 8),
              _buildDropdownCard(
                icon: Icons.person,
                label: 'Captain / Copilot',
                value: _selectedCrewRole,
                items: _crewRoles,
                onChanged: (v) => setState(() => _selectedCrewRole = v),
              ),
              const SizedBox(height: 16),

              // ── PF / PNF select ──
              _buildSectionLabel('Pilot Flying Role'),
              const SizedBox(height: 8),
              _buildDropdownCard(
                icon: Icons.flight,
                label: 'PF / PNF',
                value: _selectedPilotRole,
                items: _pilotRoles,
                onChanged: (v) => setState(() => _selectedPilotRole = v),
              ),
              const SizedBox(height: 24),

              // ── Air & Block calculated ──
              _buildSectionLabel('Calculated Times'),
              const SizedBox(height: 8),
              _buildAirBlockDisplay(),
              const SizedBox(height: 32),

              // ── Save / Finalize Button ──
              if (_isEditMode) _buildSaveButton() else _buildFinalizeButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  ACTION BUTTONS: Add Flight Info / Edit Flight Info
  // ══════════════════════════════════════════════════════════════
  Widget _buildActionButtons() {
    final editButton = Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // Pass existing flight data for pre-filling
          final editArgs = <String, dynamic>{};
          if (_detail != null) {
            editArgs['flight_number'] = _detail!.flightNumber;
            editArgs['flight_real_date'] = _detail!.flightRealDate;
            editArgs['airline_route_id'] = _detail!.airlineRouteId;
            editArgs['origin_iata_code'] = _detail!.originIataCode;
            editArgs['destination_iata_code'] = _detail!.destinationIataCode;
            editArgs['airline_name'] = _detail!.airlineCode;
            editArgs['daily_logbook_id'] = _detail!.dailyLogbookId;
            editArgs['license_plate'] = _detail!.licensePlate;
          }
          Navigator.pushNamed(context, '/new-flight', arguments: editArgs);
        },
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('Edit'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF667eea),
          side: const BorderSide(color: Color(0xFF667eea)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );

    // In edit mode, show only the Edit button
    if (_isEditMode) {
      return Row(children: [editButton]);
    }

    // In non-edit mode, show both Add Flight Info + Edit
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/new-flight');
            },
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('Add Flight Info'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4facfe),
              side: const BorderSide(color: Color(0xFF4facfe)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        editButton,
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  FLIGHT SUMMARY CARD — shows real data in edit mode
  // ══════════════════════════════════════════════════════════════
  Widget _buildFlightSummaryCard() {
    final flightNum = _detail?.flightNumber ?? '--';
    final route = _detail?.routeDisplay ?? '-- → --';
    final aircraft = _detail?.licensePlate ?? '--';
    final date = _detail?.formattedDate ?? '--';
    final departure = _detail?.startTime ?? '--:--';
    final arrival = _detail?.endTime ?? '--:--';

    return Container(
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
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.flight, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  _isEditMode ? 'Flight $flightNum' : 'Flight Summary',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isEditMode && _detail?.airlineCode != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _detail!.airlineCode!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildSummaryRow('Flight #', flightNum),
          _buildSummaryRow('Route', route),
          _buildSummaryRow('Aircraft', aircraft),
          _buildSummaryRow('Date', date),
          _buildSummaryRow('Departure', departure),
          _buildSummaryRow('Arrival', arrival),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6c757d),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
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

  // ══════════════════════════════════════════════════════════════
  //  PAX, IN, ON, OUT, OFF — input fields
  // ══════════════════════════════════════════════════════════════
  Widget _buildPaxTimesInputs() {
    return Container(
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
      child: Column(
        children: [
          _buildInputField(
            label: 'PAX',
            hint: 'Number of passengers',
            controller: _paxController,
            icon: Icons.people_outline,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'OUT',
                  hint: 'HH:MM',
                  controller: _outController,
                  icon: Icons.logout,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'OFF',
                  hint: 'HH:MM',
                  controller: _offController,
                  icon: Icons.flight_takeoff,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'ON',
                  hint: 'HH:MM',
                  controller: _onController,
                  icon: Icons.flight_land,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'IN',
                  hint: 'HH:MM',
                  controller: _inController,
                  icon: Icons.login,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1a1a2e),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFf8f9fa),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFe9ecef)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFadb5bd),
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF4facfe), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  DROPDOWN CARDS — Captain/Copilot, PF/PNF
  // ══════════════════════════════════════════════════════════════
  Widget _buildDropdownCard({
    required IconData icon,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              color: const Color(0xFF4facfe).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4facfe), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFadb5bd),
                    fontSize: 14,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF4facfe),
                ),
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                items:
                    items
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  AIR & BLOCK — calculated display (shows real data if available)
  // ══════════════════════════════════════════════════════════════
  Widget _buildAirBlockDisplay() {
    final airTime =
        _detail?.airTime != null
            ? _formatTimeForField(_detail!.airTime)
            : '--:--';
    final blockTime =
        _detail?.blockTime != null
            ? _formatTimeForField(_detail!.blockTime)
            : '--:--';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4facfe).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4facfe).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                'Calculated Times',
                style: TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTimeDisplayItem('Air Time', airTime)),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF4facfe).withValues(alpha: 0.2),
              ),
              Expanded(child: _buildTimeDisplayItem('Block Time', blockTime)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplayItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4facfe),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6c757d), fontSize: 13),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  SAVE BUTTON — dispatches update event
  // ══════════════════════════════════════════════════════════════
  Widget _buildSaveButton() {
    return BlocBuilder<LogbookBloc, LogbookState>(
      builder: (context, state) {
        final isLoading = state is LogbookLoading;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _onSave,
            icon:
                isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.save_outlined, size: 20),
            label: Text(
              isLoading ? 'Saving...' : 'Save Changes',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
        );
      },
    );
  }

  void _onSave() {
    if (_detail == null) return;

    final pax = int.tryParse(_paxController.text) ?? _detail!.passengers ?? 0;

    context.read<LogbookBloc>().add(
      UpdateLogbookDetailEvent(
        originalDetail: _detail!,
        dailyLogbookId: _detail!.dailyLogbookId ?? '',
        passengers: pax,
        outTime: _formatTimeForApi(_outController.text),
        takeoffTime: _formatTimeForApi(_offController.text),
        landingTime: _formatTimeForApi(_onController.text),
        inTime: _formatTimeForApi(_inController.text),
        pilotRole: _selectedPilotRole ?? _detail!.pilotRole ?? '',
        crewRole: _selectedCrewRole?.toLowerCase() ?? 'captain',
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  FINALIZE BUTTON
  // ══════════════════════════════════════════════════════════════
  Widget _buildFinalizeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showComingSoon('Finalize');
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: const Text(
          'Finalize',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4facfe),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  HELPERS
  // ══════════════════════════════════════════════════════════════
  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF6c757d),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        backgroundColor: const Color(0xFF4facfe),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
