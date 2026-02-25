import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/features/flight_summary/presentation/bloc/flight_summary_bloc.dart';
import 'package:flight_hours_app/features/flight_summary/presentation/bloc/flight_summary_event.dart';
import 'package:flight_hours_app/features/flight_summary/presentation/bloc/flight_summary_state.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_hours_summary_model.dart';
import 'package:flight_hours_app/features/flight_summary/data/models/flight_alerts_model.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  // Period filter state
  int _selectedPeriodIndex = 0;
  final List<String> _periods = [
    'Monthly',
    'Bimonthly',
    'Quarterly',
    'Semi-annual',
    'Annual',
  ];
  // Maps display names to API period values
  final List<String> _periodValues = [
    'monthly',
    'bimonthly',
    'quarterly',
    'semiannual',
    'annual',
  ];

  // Month tab state
  int _selectedMonthIndex = DateTime.now().month - 1;
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Data from BLoC
  FlightHoursSummaryData? _summaryData;
  List<FlightAlertData> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadFlightAlerts();
    _loadFlightHoursSummary();
  }

  void _loadFlightAlerts() {
    context.read<FlightSummaryBloc>().add(LoadFlightAlerts());
  }

  void _loadFlightHoursSummary() {
    final year = DateTime.now().year;
    final month = _selectedMonthIndex + 1;
    final referenceDate = '$year-${month.toString().padLeft(2, '0')}-15';
    context.read<FlightSummaryBloc>().add(
      LoadFlightHoursSummary(
        referenceDate: referenceDate,
        period: _periodValues[_selectedPeriodIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1a1a2e)),
        ),
        title: const Text(
          'Alerts',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<FlightSummaryBloc, FlightSummaryState>(
        listener: (context, state) {
          if (state is FlightHoursSummarySuccess) {
            setState(() => _summaryData = state.data);
          } else if (state is FlightAlertsSuccess) {
            setState(() => _alerts = state.alerts);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAlertCards(),
              const SizedBox(height: 28),
              const Divider(color: Color(0xFFe9ecef)),
              const SizedBox(height: 20),
              _buildFlightHoursSummary(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== ALERT CARDS ====================
  Widget _buildAlertCards() {
    if (_alerts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFe9ecef)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF00b894),
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'No active alerts',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'All flight parameters are within limits',
              style: TextStyle(color: Color(0xFF6c757d), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          _alerts.map((alert) {
            final isHourAlert = alert.isHourLimit;
            final icon =
                isHourAlert ? Icons.access_time_filled : Icons.flight_land;

            // 3-phase coloring: WARNING=red, INFO=orange, NOTICE=gray
            Color color;
            if (alert.isWarning) {
              color = const Color(0xFFe17055); // red
            } else if (alert.isInfo) {
              color = const Color(0xFFFF9F40); // orange
            } else {
              color = const Color(0xFF8395a7); // gray (NOTICE)
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAlertCard(
                icon: icon,
                iconColor: color,
                borderColor: color,
                title: _getAlertTitle(alert.type),
                description: alert.message,
                severity: alert.severity,
              ),
            );
          }).toList(),
    );
  }

  String _getAlertTitle(String type) {
    switch (type) {
      case 'HOUR_LIMIT_15_DAYS':
        return '15-Day Hour Limit';
      case 'HOUR_LIMIT_MONTHLY':
        return 'Monthly Hour Limit';
      case 'HOUR_LIMIT_QUARTERLY':
        return 'Quarterly Hour Limit';
      case 'HOUR_LIMIT_ANNUAL':
        return 'Annual Hour Limit';
      case 'MIN_LANDINGS_90_DAYS':
        return 'Landing Currency';
      default:
        return 'Flight Alert';
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'WARNING':
        return const Color(0xFFe17055); // red
      case 'INFO':
        return const Color(0xFFFF9F40); // orange
      case 'NOTICE':
      default:
        return const Color(0xFF8395a7); // gray
    }
  }

  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String description,
    required String severity,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF1a1a2e),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(
                          severity,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        severity,
                        style: TextStyle(
                          color: _getSeverityColor(severity),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== FLIGHT HOURS SUMMARY ====================
  Widget _buildFlightHoursSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flight Hours Summary',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPeriodFilters(),
        const SizedBox(height: 16),
        _buildMonthTabs(),
        const SizedBox(height: 20),
        _buildStatCardsGrid(),
      ],
    );
  }

  // ==================== PERIOD FILTER CHIPS ====================
  Widget _buildPeriodFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_periods.length, (index) {
          final isSelected = _selectedPeriodIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedPeriodIndex = index);
                _loadFlightHoursSummary();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? const LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          )
                          : null,
                  color: isSelected ? null : const Color(0xFFf8f9fa),
                  borderRadius: BorderRadius.circular(24),
                  border:
                      isSelected
                          ? null
                          : Border.all(color: const Color(0xFFe9ecef)),
                ),
                child: Text(
                  _periods[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF6c757d),
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==================== MONTH TABS ====================
  Widget _buildMonthTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_months.length, (index) {
          final isSelected = _selectedMonthIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedMonthIndex = index);
              _loadFlightHoursSummary();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isSelected
                            ? const Color(0xFF4facfe)
                            : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                _months[index],
                style: TextStyle(
                  color:
                      isSelected
                          ? const Color(0xFF4facfe)
                          : const Color(0xFF6c757d),
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==================== STAT CARDS GRID ====================
  Widget _buildStatCardsGrid() {
    // Extract values from summary data
    final totalHours = _summaryData?.totalHours ?? '0:00';
    final breakdown = _summaryData?.breakdown ?? {};
    final pfHours = breakdown['PF'] ?? '0:00';
    final pmHours = breakdown['PM'] ?? '0:00';
    final pftoHours = breakdown['PFTO'] ?? '0:00';
    final pflHours = breakdown['PFL'] ?? '0:00';

    return Column(
      children: [
        // Row 1: Total Hours + PF
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Total Hours',
                value: totalHours,
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'Pilot Flying (PF)',
                value: pfHours,
                icon: Icons.flight_takeoff,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: PM + PFTO
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Pilot Monitoring (PM)',
                value: pmHours,
                icon: Icons.visibility,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'PF Take-Off (PFTO)',
                value: pftoHours,
                icon: Icons.north_east,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Full-width: PFL
        _buildStatCard(
          label: 'Pilot For Landing (PFL)',
          value: pflHours,
          icon: Icons.flight_land,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(18),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF4facfe), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
