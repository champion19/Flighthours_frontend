import 'package:flight_hours_app/features/logbook/domain/entities/daily_logbook_entity.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/logbook_detail_entity.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_bloc.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_event.dart';
import 'package:flight_hours_app/features/logbook/presentation/bloc/logbook_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page showing flight record summary cards for a daily logbook.
/// Fetches real data via LogbookBloc → GET /daily-logbooks/{id}/details.
class FlightRecordsListPage extends StatefulWidget {
  const FlightRecordsListPage({super.key});

  @override
  State<FlightRecordsListPage> createState() => _FlightRecordsListPageState();
}

class _FlightRecordsListPageState extends State<FlightRecordsListPage> {
  DailyLogbookEntity? _logbook;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_logbook == null) {
      _logbook =
          ModalRoute.of(context)?.settings.arguments as DailyLogbookEntity?;
      if (_logbook != null) {
        // Trigger BLoC to fetch details for this logbook
        context.read<LogbookBloc>().add(SelectDailyLogbook(_logbook!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          // Reset BLoC to logbook list so logbook_page shows the list
          context.read<LogbookBloc>().add(const FetchDailyLogbooks());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // Reset BLoC to logbook list before going back
              context.read<LogbookBloc>().add(const FetchDailyLogbooks());
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF4facfe),
              size: 22,
            ),
          ),
          title: Column(
            children: [
              const Text(
                'Flight Records',
                style: TextStyle(
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFe9ecef)),
          ),
        ),
        body: BlocBuilder<LogbookBloc, LogbookState>(
          builder: (context, state) {
            if (state is LogbookLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF4facfe)),
              );
            }

            if (state is LogbookError) {
              return _buildErrorState(state.message);
            }

            if (state is LogbookDetailsLoaded) {
              return _buildContent(state.details);
            }

            // Initial or unexpected state — show empty
            return _buildContent([]);
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  CONTENT — header + list
  // ══════════════════════════════════════════════════════════════
  Widget _buildContent(List<LogbookDetailEntity> details) {
    return Column(
      children: [
        // Records count + Add button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4facfe).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${details.length} flight${details.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Color(0xFF4facfe),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/new-flight');
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Flight'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4facfe),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),

        // List of summary cards
        Expanded(
          child:
              details.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      return _buildFlightSummaryCard(context, details[index]);
                    },
                  ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  FLIGHT SUMMARY CARD — compact card per flight record
  // ══════════════════════════════════════════════════════════════
  Widget _buildFlightSummaryCard(
    BuildContext context,
    LogbookDetailEntity detail,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail form passing both logbook and flight detail
        Navigator.pushNamed(
          context,
          '/daily-logbook-detail-form',
          arguments: {'logbook': _logbook, 'detail': detail},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Card header with flight number ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flight, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Flight ${detail.flightNumber ?? '—'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Airline code badge
                  if (detail.airlineCode != null)
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
                        detail.airlineCode!,
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

            // ── Card body ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Route & Aircraft row
                  Row(
                    children: [
                      _buildInfoChip(Icons.route, detail.routeDisplay),
                      const SizedBox(width: 10),
                      _buildInfoChip(
                        Icons.airplanemode_active,
                        detail.licensePlate ?? '—',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date row
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        detail.formattedDate,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Tap hint ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFf8f9fa),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: Color(0xFFadb5bd),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Tap to view details',
                    style: TextStyle(color: Color(0xFFadb5bd), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFf8f9fa),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: const Color(0xFF4facfe)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  EMPTY STATE
  // ══════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 72,
            color: const Color(0xFF4facfe).withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No flights recorded yet',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap "Add Flight" to get started',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  ERROR STATE
  // ══════════════════════════════════════════════════════════════
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFe17055)),
            const SizedBox(height: 16),
            const Text(
              'Error loading flights',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Color(0xFF6c757d), fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_logbook != null) {
                  context.read<LogbookBloc>().add(
                    SelectDailyLogbook(_logbook!),
                  );
                }
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4facfe),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
