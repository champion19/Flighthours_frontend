import 'package:flight_hours_app/features/airport/domain/entities/airport_entity.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_bloc.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_event.dart';
import 'package:flight_hours_app/features/airport/presentation/bloc/airport_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen to select an airport from the list
/// Returns the selected AirportEntity when popped
class AirportSelectionPage extends StatefulWidget {
  final String? currentAirportId;

  const AirportSelectionPage({super.key, this.currentAirportId});

  @override
  State<AirportSelectionPage> createState() => _AirportSelectionPageState();
}

class _AirportSelectionPageState extends State<AirportSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AirportEntity> _filteredAirports = [];
  List<AirportEntity> _allAirports = [];
  String? _selectedAirportId;

  @override
  void initState() {
    super.initState();
    _selectedAirportId = widget.currentAirportId;
    // Load airports
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AirportBloc>().add(FetchAirports());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAirports(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAirports = _allAirports;
      } else {
        _filteredAirports =
            _allAirports.where((airport) {
              final nameLower = airport.name.toLowerCase();
              final codeLower = (airport.code ?? '').toLowerCase();
              final iataLower = (airport.iataCode ?? '').toLowerCase();
              final cityLower = (airport.city ?? '').toLowerCase();
              final queryLower = query.toLowerCase();
              return nameLower.contains(queryLower) ||
                  codeLower.contains(queryLower) ||
                  iataLower.contains(queryLower) ||
                  cityLower.contains(queryLower);
            }).toList();
      }
    });
  }

  void _selectAirport(AirportEntity airport) {
    Navigator.of(context).pop(airport);
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
            Expanded(child: _buildAirportList()),
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
                  'Select Airport',
                  style: TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Choose your airport from the list',
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
            child: const Icon(
              Icons.connecting_airports,
              color: Colors.white,
              size: 24,
            ),
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
        onChanged: _filterAirports,
        style: const TextStyle(color: Color(0xFF1a1a2e), fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search by name, code or city...',
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

  Widget _buildAirportList() {
    return BlocBuilder<AirportBloc, AirportState>(
      builder: (context, state) {
        if (state is AirportLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF4facfe)),
                SizedBox(height: 16),
                Text(
                  'Loading airports...',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (state is AirportError) {
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
                    context.read<AirportBloc>().add(FetchAirports());
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

        if (state is AirportSuccess) {
          // Update the full list when data arrives
          if (_allAirports.isEmpty ||
              _allAirports.length != state.airports.length) {
            _allAirports = state.airports;
            if (_filteredAirports.isEmpty) {
              _filteredAirports = _allAirports;
            }
          }
        }

        if (_filteredAirports.isEmpty && _allAirports.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight_land, size: 64, color: Color(0xFF6c757d)),
                SizedBox(height: 16),
                Text(
                  'No airports available',
                  style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (_filteredAirports.isEmpty) {
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
                  'No airports match "${_searchController.text}"',
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
          itemCount: _filteredAirports.length,
          itemBuilder: (context, index) {
            final airport = _filteredAirports[index];
            final isSelected = airport.id == _selectedAirportId;
            return _buildAirportCard(airport, isSelected);
          },
        );
      },
    );
  }

  Widget _buildAirportCard(AirportEntity airport, bool isSelected) {
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
          onTap: () => _selectAirport(airport),
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
                      airport.iataCode?.isNotEmpty == true
                          ? airport.iataCode!
                              .substring(
                                0,
                                airport.iataCode!.length > 3
                                    ? 3
                                    : airport.iataCode!.length,
                              )
                              .toUpperCase()
                          : airport.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF4facfe),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airport.name,
                        style: TextStyle(
                          color: const Color(0xFF1a1a2e),
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      if (airport.city != null && airport.city!.isNotEmpty)
                        Text(
                          '${airport.city}${airport.iataCode != null ? ' (${airport.iataCode})' : ''}',
                          style: const TextStyle(
                            color: Color(0xFF6c757d),
                            fontSize: 12,
                          ),
                        )
                      else if (airport.iataCode != null &&
                          airport.iataCode!.isNotEmpty)
                        Text(
                          airport.iataCode!,
                          style: const TextStyle(
                            color: Color(0xFF6c757d),
                            fontSize: 12,
                          ),
                        ),
                    ],
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
