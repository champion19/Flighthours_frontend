import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen to select an airline from the list
/// Returns the selected AirlineEntity when popped
class AirlineSelectionPage extends StatefulWidget {
  final String? currentAirlineId;

  const AirlineSelectionPage({super.key, this.currentAirlineId});

  @override
  State<AirlineSelectionPage> createState() => _AirlineSelectionPageState();
}

class _AirlineSelectionPageState extends State<AirlineSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AirlineEntity> _filteredAirlines = [];
  List<AirlineEntity> _allAirlines = [];
  String? _selectedAirlineId;

  @override
  void initState() {
    super.initState();
    _selectedAirlineId = widget.currentAirlineId;
    // Load airlines
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AirlineBloc>().add(FetchAirlines());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAirlines(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAirlines = _allAirlines;
      } else {
        _filteredAirlines =
            _allAirlines.where((airline) {
              final nameLower = airline.name.toLowerCase();
              final codeLower = (airline.code ?? '').toLowerCase();
              final queryLower = query.toLowerCase();
              return nameLower.contains(queryLower) ||
                  codeLower.contains(queryLower);
            }).toList();
      }
    });
  }

  void _selectAirline(AirlineEntity airline) {
    Navigator.of(context).pop(airline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildAirlineList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Airline',
                  style: TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Choose your airline from the list',
                  style: TextStyle(
                    color: const Color(0xFF6c757d),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchController,
        onChanged: _filterAirlines,
        style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search by name or code...',
          hintStyle: const TextStyle(color: Color(0xFF6c757d)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4facfe)),
          filled: true,
          fillColor: const Color(0xFFf8f9fa),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF212529)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4facfe), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAirlineList() {
    return BlocBuilder<AirlineBloc, AirlineState>(
      builder: (context, state) {
        if (state is AirlineLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4facfe)),
                SizedBox(height: 16),
                Text(
                  'Loading airlines...',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is AirlineError) {
          return Center(
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
                  state.message,
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AirlineBloc>().add(FetchAirlines());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4facfe),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is AirlineSuccess) {
          // Update the full list when data arrives
          if (_allAirlines.isEmpty ||
              _allAirlines.length != state.airlines.length) {
            _allAirlines = state.airlines;
            if (_filteredAirlines.isEmpty) {
              _filteredAirlines = _allAirlines;
            }
          }
        }

        if (_filteredAirlines.isEmpty && _allAirlines.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.airplanemode_inactive,
                  size: 64,
                  color: Color(0xFF6c757d),
                ),
                SizedBox(height: 16),
                Text(
                  'No airlines available',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (_filteredAirlines.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: Color(0xFF6c757d),
                ),
                const SizedBox(height: 16),
                Text(
                  'No airlines match "${_searchController.text}"',
                  style: const TextStyle(
                    color: Color(0xFF6c757d),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _filteredAirlines.length,
          itemBuilder: (context, index) {
            final airline = _filteredAirlines[index];
            final isSelected = airline.id == _selectedAirlineId;
            return _buildAirlineCard(airline, isSelected);
          },
        );
      },
    );
  }

  Widget _buildAirlineCard(AirlineEntity airline, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isSelected
                ? const Color(0xFF4facfe).withValues(alpha: 0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF4facfe) : const Color(0xFF212529),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAirline(airline),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient:
                        isSelected
                            ? const LinearGradient(
                              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                            )
                            : null,
                    color: isSelected ? null : const Color(0xFFe9ecef),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      airline.code?.isNotEmpty == true
                          ? airline.code!
                              .substring(
                                0,
                                airline.code!.length > 2
                                    ? 2
                                    : airline.code!.length,
                              )
                              .toUpperCase()
                          : airline.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF4facfe),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    airline.name,
                    style: TextStyle(
                      color: const Color(0xFF1a1a2e),
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: const Color(0xFF4facfe).withValues(alpha: 0.5),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
