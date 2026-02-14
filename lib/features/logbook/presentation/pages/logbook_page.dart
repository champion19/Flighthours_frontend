import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
            // Show success messages for CRUD operations
            if (state is LogbookDetailDeleted ||
                state is DailyLogbookCreated ||
                state is DailyLogbookStatusChanged ||
                state is DailyLogbookDeleted) {
              String message = '';
              if (state is LogbookDetailDeleted) message = state.message;
              if (state is DailyLogbookCreated) message = state.message;
              if (state is DailyLogbookStatusChanged) message = state.message;
              if (state is DailyLogbookDeleted) message = state.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
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
        _buildHeader(title: 'My Logbooks', showBackButton: true),
        // Add New Entry button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogbookFormDialog(),
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text(
                'Add New Entry',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4facfe),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4facfe).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              size: 64,
              color: const Color(0xFF4facfe).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No logbooks yet',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first logbook entry to get started',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showLogbookFormDialog(),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Create First Entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4facfe),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card for each daily logbook — matches wireframe mockup
  Widget _buildLogbookCard(DailyLogbookEntity logbook) {
    final isActive = logbook.isActive;
    final statusColor =
        isActive ? const Color(0xFF28a745) : const Color(0xFF6c757d);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Date + Book Page | Status badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${logbook.fullFormattedDate}',
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Book Page: ${logbook.bookPage ?? 'N/A'}',
                      style: const TextStyle(
                        color: Color(0xFF6c757d),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge — visual indicator only
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      logbook.displayStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isActive ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Bottom row: View Info + Activate/Deactivate + Delete buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showLogbookInfoBottomSheet(logbook),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View Info'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4facfe),
                    side: const BorderSide(color: Color(0xFF4facfe)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (isActive) {
                      context.read<LogbookBloc>().add(
                        DeactivateDailyLogbookEvent(logbook.uuid ?? logbook.id),
                      );
                    } else {
                      context.read<LogbookBloc>().add(
                        ActivateDailyLogbookEvent(logbook.uuid ?? logbook.id),
                      );
                    }
                  },
                  icon: Icon(
                    isActive
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 16,
                  ),
                  label: Text(isActive ? 'Deactivate' : 'Activate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        isActive
                            ? const Color(0xFFf5576c)
                            : const Color(0xFF28a745),
                    side: BorderSide(
                      color:
                          isActive
                              ? const Color(0xFFf5576c)
                              : const Color(0xFF28a745),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Delete button — full width
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmDeleteDailyLogbook(logbook),
              icon: const Icon(Icons.delete_outline, size: 16),
              label: const Text('Delete Logbook'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                side: BorderSide(color: Colors.red.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
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

  /// Table view for flight details - using cards for mobile-friendly design
  Widget _buildDetailsTable(List<LogbookDetailEntity> details) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: details.length,
      itemBuilder: (context, index) {
        return _buildFlightCard(details[index]);
      },
    );
  }

  /// Flight card for each detail - mobile-friendly design
  Widget _buildFlightCard(LogbookDetailEntity detail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Card header with flight number and role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Flight number
                const Icon(Icons.flight, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Flight ${detail.flightNumber ?? '--'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Modality badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    detail.displayPilotRole,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card body with details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Row 1: Route and Aircraft
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.route,
                        'Route',
                        detail.routeDisplay,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.airplanemode_active,
                        'Aircraft',
                        detail.licensePlate ?? '--',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Row 2: Date and Times
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.calendar_today,
                        'Date',
                        detail.formattedDate,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.schedule,
                        'Time',
                        '${detail.startTime} - ${detail.endTime}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // View button
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'View',
                      color: const Color(0xFF4facfe),
                      onTap: () => _viewFlightDetail(detail),
                    ),
                    const SizedBox(width: 8),
                    // Edit button
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF667eea),
                      onTap: () => _editFlightDetail(detail),
                    ),
                    const SizedBox(width: 8),
                    // Delete button
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: Colors.red.shade400,
                      onTap: () => _confirmDeleteDetail(detail),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info item with icon, label and value
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4facfe)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF6c757d), fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Action button with icon and label
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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

  /// Confirmation dialog for deleting a daily logbook
  void _confirmDeleteDailyLogbook(DailyLogbookEntity logbook) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Logbook'),
            content: Text(
              'Are you sure you want to delete the logbook from ${logbook.fullFormattedDate}?\n\nThis logbook and all its flight records will be permanently deleted. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  this.context.read<LogbookBloc>().add(
                    DeleteDailyLogbookEvent(logbook.uuid ?? logbook.id),
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

  /// Show logbook info in a bottom sheet — data from GET /daily-logbooks/:id
  void _showLogbookInfoBottomSheet(DailyLogbookEntity logbook) {
    final isActive = logbook.isActive;
    final statusColor =
        isActive ? const Color(0xFF28a745) : const Color(0xFF6c757d);

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
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: const Text(
                        'Logbook Details',
                        style: TextStyle(
                          color: Color(0xFF1a1a2e),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            logbook.displayStatus,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isActive ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: statusColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Detail rows
                _buildLogbookInfoRow(
                  Icons.calendar_today,
                  'Log Date',
                  logbook.fullFormattedDate,
                ),
                _buildLogbookInfoRow(
                  Icons.book_outlined,
                  'Book Page',
                  logbook.bookPage?.toString() ?? 'N/A',
                ),
                _buildLogbookInfoRow(
                  Icons.toggle_on_outlined,
                  'Status',
                  logbook.displayStatus,
                  valueColor: statusColor,
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
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

  /// Info row widget for logbook bottom sheet
  Widget _buildLogbookInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF4facfe)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF1a1a2e),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Show the create logbook form dialog
  void _showLogbookFormDialog() {
    final dateController = TextEditingController();
    final bookPageController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New Logbook Entry',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a2e),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date field
                    const Text(
                      'Log Date *',
                      style: TextStyle(
                        color: Color(0xFF6c757d),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Select date',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Color(0xFF4facfe),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFe9ecef),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFe9ecef),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4facfe),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? now,
                          firstDate: DateTime(2020),
                          lastDate: now,
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                            dateController.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(picked);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Book page field
                    const Text(
                      'Book Page (optional)',
                      style: TextStyle(
                        color: Color(0xFF6c757d),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: bookPageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g. 42',
                        prefixIcon: const Icon(
                          Icons.book_outlined,
                          size: 18,
                          color: Color(0xFF4facfe),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFe9ecef),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFe9ecef),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF4facfe),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF6c757d)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate == null) {
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        SnackBar(
                          content: const Text('Please select a date'),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      return;
                    }
                    final bookPage = int.tryParse(bookPageController.text);
                    Navigator.of(dialogContext).pop();

                    this.context.read<LogbookBloc>().add(
                      CreateDailyLogbookEvent(
                        logDate: selectedDate!,
                        bookPage: bookPage,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4facfe),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Create',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
