import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main page for displaying logbook details in a table format
/// Matches the Figma design with MODALITY, FLIGHT #, FROM-TO, A/C REG, DATE, START, END, ACTIONS columns
class LogbookPage extends StatefulWidget {
  const LogbookPage({super.key});

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  @override
  void initState() {
    super.initState();
    // Load daily logbooks when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogbookBloc>().add(const FetchDailyLogbooks());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: BlocConsumer<LogbookBloc, LogbookState>(
          listener: (context, state) {
            // Show success message when a detail is deleted
            if (state is LogbookDetailDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFF28a745),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            // Show error messages
            if (state is LogbookError) {
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
          builder: (context, state) {
            if (state is LogbookLoading) {
              return _buildLoadingState();
            }

            if (state is DailyLogbooksLoaded) {
              return _buildLogbookListView(state.logbooks);
            }

            if (state is LogbookDetailsLoaded ||
                state is LogbookDetailDeleted) {
              final details =
                  state is LogbookDetailsLoaded
                      ? state.details
                      : (state as LogbookDetailDeleted).details;
              final selectedLogbook =
                  state is LogbookDetailsLoaded
                      ? state.selectedLogbook
                      : (state as LogbookDetailDeleted).selectedLogbook;
              return _buildDetailsView(selectedLogbook, details);
            }

            if (state is LogbookError) {
              return _buildErrorState(state.message);
            }

            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  /// Loading state with spinner
  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildHeader(title: 'Logbook', showBackButton: true),
        const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4facfe)),
                SizedBox(height: 16),
                Text(
                  'Loading logbook...',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Error state with retry button
  Widget _buildErrorState(String message) {
    return Column(
      children: [
        _buildHeader(title: 'Logbook', showBackButton: true),
        Expanded(
          child: Center(
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
                  message,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<LogbookBloc>().add(const FetchDailyLogbooks());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4facfe),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// View for listing daily logbooks (first screen)
  Widget _buildLogbookListView(List<DailyLogbookEntity> logbooks) {
    return Column(
      children: [
        _buildHeader(title: 'Select Logbook', showBackButton: true),
        Expanded(
          child:
              logbooks.isEmpty
                  ? _buildEmptyLogbooksState()
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logbooks.length,
                    itemBuilder: (context, index) {
                      final logbook = logbooks[index];
                      return _buildLogbookCard(logbook);
                    },
                  ),
        ),
      ],
    );
  }

  /// Empty state when no logbooks exist
  Widget _buildEmptyLogbooksState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80,
            color: const Color(0xFF4facfe).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No logbooks found',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your flight logbooks will appear here',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Card for each daily logbook
  Widget _buildLogbookCard(DailyLogbookEntity logbook) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<LogbookBloc>().add(SelectDailyLogbook(logbook));
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.book, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        logbook.fullFormattedDate,
                        style: const TextStyle(
                          color: Color(0xFF1a1a2e),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Page: ${logbook.bookPage ?? 'N/A'}',
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        logbook.isActive
                            ? const Color(0xFF28a745).withValues(alpha: 0.1)
                            : const Color(0xFF6c757d).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    logbook.displayStatus,
                    style: TextStyle(
                      color:
                          logbook.isActive
                              ? const Color(0xFF28a745)
                              : const Color(0xFF6c757d),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF4facfe),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// View for displaying logbook details (table view - main design)
  Widget _buildDetailsView(
    DailyLogbookEntity logbook,
    List<LogbookDetailEntity> details,
  ) {
    return Column(
      children: [
        _buildHeader(
          title: 'Logbook',
          showBackButton: true,
          onBackPressed: () {
            context.read<LogbookBloc>().add(const ClearSelectedLogbook());
          },
          subtitle: logbook.fullFormattedDate,
        ),
        Expanded(
          child:
              details.isEmpty
                  ? _buildEmptyDetailsState()
                  : _buildDetailsTable(details),
        ),
      ],
    );
  }

  /// Empty state when no flight details exist
  Widget _buildEmptyDetailsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 80,
            color: const Color(0xFF4facfe).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No flights recorded',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first flight using the + button',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Table view for flight details (matches design)
  Widget _buildDetailsTable(List<LogbookDetailEntity> details) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Table header
          _buildTableHeader(),
          // Table body
          Expanded(
            child: ListView.separated(
              itemCount: details.length,
              separatorBuilder:
                  (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
              itemBuilder: (context, index) {
                return _buildTableRow(details[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Table header row
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF4facfe),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('MODALITY', flex: 2),
          _buildHeaderCell('FLIGHT #', flex: 2),
          _buildHeaderCell('FROM-TO', flex: 2),
          _buildHeaderCell('A/C REG.', flex: 2),
          _buildHeaderCell('DATE', flex: 2),
          _buildHeaderCell('START', flex: 2),
          _buildHeaderCell('END', flex: 2),
          _buildHeaderCell('ACTIONS', flex: 2),
        ],
      ),
    );
  }

  /// Header cell widget
  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Table row for each flight detail
  Widget _buildTableRow(LogbookDetailEntity detail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // MODALITY
          Expanded(
            flex: 2,
            child: Text(
              detail.displayPilotRole,
              style: const TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // FLIGHT #
          Expanded(
            flex: 2,
            child: Text(
              detail.flightNumber ?? '--',
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // FROM-TO
          Expanded(
            flex: 2,
            child: Text(
              detail.routeDisplay,
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // A/C REG.
          Expanded(
            flex: 2,
            child: Text(
              detail.licensePlate ?? '--',
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // DATE
          Expanded(
            flex: 2,
            child: Text(
              detail.formattedDate,
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // START
          Expanded(
            flex: 2,
            child: Text(
              detail.startTime,
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // END
          Expanded(
            flex: 2,
            child: Text(
              detail.endTime,
              style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 13),
            ),
          ),
          // ACTIONS
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // View button
                InkWell(
                  onTap: () => _viewFlightDetail(detail),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF4facfe),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Edit button
                InkWell(
                  onTap: () => _editFlightDetail(detail),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF4facfe),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Delete button
                InkWell(
                  onTap: () => _confirmDeleteDetail(detail),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red.withValues(alpha: 0.7),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Header widget with back button and title
  Widget _buildHeader({
    required String title,
    required bool showBackButton,
    VoidCallback? onBackPressed,
    String? subtitle,
  }) {
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
          if (showBackButton)
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
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              ),
            ),
          if (showBackButton) const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF6c757d),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          if (showBackButton) const SizedBox(width: 56), // Balance
        ],
      ),
    );
  }

  /// View flight detail in bottom sheet
  void _viewFlightDetail(LogbookDetailEntity detail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailBottomSheet(detail),
    );
  }

  /// Bottom sheet with full flight detail information
  Widget _buildDetailBottomSheet(LogbookDetailEntity detail) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
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

            // Title with flight info
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
                      Text(
                        'Flight ${detail.flightNumber ?? 'N/A'}',
                        style: const TextStyle(
                          color: Color(0xFF1a1a2e),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        detail.routeDisplay,
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRoleBadge(detail.displayPilotRole),
              ],
            ),
            const SizedBox(height: 24),

            // Route visualization
            _buildRouteVisualization(detail),
            const SizedBox(height: 24),

            // Details section
            const Text(
              'Flight Details',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildDetailRow('Date', detail.formattedDate),
            _buildDetailRow('Aircraft', detail.aircraftDisplay),
            _buildDetailRow('Passengers', '${detail.passengers ?? 0}'),
            _buildDetailRow('Flight Type', detail.flightType ?? 'N/A'),
            _buildDetailRow('Approach', detail.approachType ?? 'N/A'),

            const SizedBox(height: 16),
            const Text(
              'Times',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildDetailRow('Block Out', _formatTimeDisplay(detail.outTime)),
            _buildDetailRow('Takeoff', _formatTimeDisplay(detail.takeoffTime)),
            _buildDetailRow('Landing', _formatTimeDisplay(detail.landingTime)),
            _buildDetailRow('Block In', _formatTimeDisplay(detail.inTime)),
            _buildDetailRow('Air Time', _formatTimeDisplay(detail.airTime)),
            _buildDetailRow('Block Time', _formatTimeDisplay(detail.blockTime)),
            _buildDetailRow('Duty Time', _formatTimeDisplay(detail.dutyTime)),

            if (detail.companionName != null) ...[
              const SizedBox(height: 16),
              _buildDetailRow('Companion', detail.companionName!),
            ],

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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Route visualization widget
  Widget _buildRouteVisualization(LogbookDetailEntity detail) {
    return Container(
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
                  detail.originIataCode ?? '???',
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeDisplay(detail.outTime),
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Flight icon
          Column(
            children: [
              const Icon(Icons.flight, color: Color(0xFF4facfe), size: 32),
              const SizedBox(height: 4),
              Container(
                width: 60,
                height: 2,
                color: const Color(0xFF4facfe).withValues(alpha: 0.3),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimeDisplay(detail.airTime),
                style: const TextStyle(color: Color(0xFF6c757d), fontSize: 12),
              ),
            ],
          ),

          // Destination
          Expanded(
            child: Column(
              children: [
                Text(
                  detail.destinationIataCode ?? '???',
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeDisplay(detail.inTime),
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
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

  /// Pilot role badge
  Widget _buildRoleBadge(String role) {
    Color badgeColor;
    switch (role) {
      case 'PF':
        badgeColor = const Color(0xFF28a745);
        break;
      case 'PM':
        badgeColor = const Color(0xFF4facfe);
        break;
      case 'PFL':
        badgeColor = const Color(0xFFf5576c);
        break;
      case 'PFTO':
        badgeColor = const Color(0xFFffc107);
        break;
      default:
        badgeColor = const Color(0xFF6c757d);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Detail row widget
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  /// Format time for display (HH:MM:SS -> HH:MM)
  String _formatTimeDisplay(String? time) {
    if (time == null) return '--:--';
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  /// Edit flight detail
  void _editFlightDetail(LogbookDetailEntity detail) {
    // TODO: Navigate to edit page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit flight ${detail.flightNumber} - Coming soon'),
        backgroundColor: const Color(0xFF4facfe),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Confirm delete dialog
  void _confirmDeleteDetail(LogbookDetailEntity detail) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Flight Record'),
            content: Text(
              'Are you sure you want to delete flight ${detail.flightNumber ?? 'N/A'} (${detail.routeDisplay})?\n\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Get the daily logbook ID from the current state
                  final state = this.context.read<LogbookBloc>().state;
                  String dailyLogbookId = '';
                  if (state is LogbookDetailsLoaded) {
                    dailyLogbookId =
                        state.selectedLogbook.uuid ?? state.selectedLogbook.id;
                  } else if (state is LogbookDetailDeleted) {
                    dailyLogbookId =
                        state.selectedLogbook.uuid ?? state.selectedLogbook.id;
                  }

                  this.context.read<LogbookBloc>().add(
                    DeleteLogbookDetail(
                      detailId: detail.uuid ?? detail.id,
                      dailyLogbookId: dailyLogbookId,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
