import 'package:flutter/material.dart';

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

  // Month tab state
  int _selectedMonthIndex = 0;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAlertCard(
              icon: Icons.access_time_filled,
              iconColor: const Color(0xFFe17055),
              borderColor: const Color(0xFFe17055),
              title: 'Flight Hours Limit',
              description:
                  'You must not exceed the maximum consecutive flight hours allowed',
              timestamp: 'Today, 10:30 AM',
            ),
            const SizedBox(height: 12),
            _buildAlertCard(
              icon: Icons.flight_land,
              iconColor: const Color(0xFFFF9F40),
              borderColor: const Color(0xFFFF9F40),
              title: 'Monthly Landings Required',
              description:
                  'You must complete the minimum number of landings required this month',
              timestamp: 'Feb 20, 2026',
            ),
            const SizedBox(height: 28),
            const Divider(color: Color(0xFFe9ecef)),
            const SizedBox(height: 20),
            _buildFlightHoursSummary(),
          ],
        ),
      ),
    );
  }

  // ==================== ALERT CARD ====================
  Widget _buildAlertCard({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String description,
    required String timestamp,
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                const SizedBox(height: 8),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: const Color(0xFF6c757d).withValues(alpha: 0.6),
                    fontSize: 12,
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
              onTap: () => setState(() => _selectedPeriodIndex = index),
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
            onTap: () => setState(() => _selectedMonthIndex = index),
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
    return Column(
      children: [
        // Row 1: Total Hours + PF
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'Total Hours',
                value: '120',
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'Pilot Flying (PF)',
                value: '48',
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
                value: '18',
                icon: Icons.visibility,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                label: 'PF Take-Off (PFTO)',
                value: '24',
                icon: Icons.north_east,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Full-width: PFL
        _buildStatCard(
          label: 'Pilot For Landing (PFL)',
          value: '30',
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
