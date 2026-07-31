import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flight_hours_app/features/crew_member/domain/entities/crew_member_entity.dart';
import 'package:flight_hours_app/features/crew_member/presentation/bloc/crew_member_bloc.dart';
import 'package:flight_hours_app/features/crew_member/presentation/bloc/crew_member_event.dart';
import 'package:flight_hours_app/features/crew_member/presentation/bloc/crew_member_state.dart';
import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_bloc.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_event.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_state.dart';
import 'package:flight_hours_app/features/logbook/domain/entities/crew_assignment_entity.dart';

const String kFirstOfficerRole = 'first_officer';

/// One row in the crew section: either the single "Primer Oficial" slot
/// (role fixed) or one of the dynamic "Tripulación de cabina" rows (role
/// pickable from the cabin_crew catalog). A row is either resolved to an
/// existing roster member ([selected] set, picked from search) or holds a
/// brand-new person's name/BP — resolved/created by the backend in the same
/// transaction as the flight save, not before.
class _CrewRow {
  String role;
  CrewMemberEntity? selected;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  String query = '';

  _CrewRow({required this.role, this.selected}) {
    if (selected != null) {
      searchController.text = selected!.name;
      bpController.text = selected!.bp ?? '';
    }
  }

  void dispose() {
    searchController.dispose();
    bpController.dispose();
  }
}

/// Optional "Tripulación" section for the Daily Logbook Detail form: Primer
/// Oficial (0-1) + Tripulación de cabina (0-N). Each row just needs a name
/// (typed or picked from a search suggestion) + cargo — nothing is sent to
/// the backend until the whole flight is saved, at which point every row
/// (existing people and brand-new ones alike) is persisted together in one
/// request via [onChanged]'s payload (`crew_member_id` for existing people,
/// `name`/`bp` for new ones — resolved server-side in the same transaction).
class CrewSection extends StatefulWidget {
  final List<CrewAssignmentEntity>? initialCrew;
  final ValueChanged<List<Map<String, String>>> onChanged;

  const CrewSection({super.key, this.initialCrew, required this.onChanged});

  @override
  State<CrewSection> createState() => CrewSectionState();
}

class CrewSectionState extends State<CrewSection> {
  _CrewRow? _firstOfficerRow;
  final List<_CrewRow> _cabinCrewRows = [];

  List<CrewMemberEntity> _roster = [];
  List<CrewMemberTypeEntity> _cabinCrewTypes = [];
  bool _isLoadingRoster = true;

  @override
  void initState() {
    super.initState();
    _loadInitialCrew();
    context.read<CrewMemberBloc>().add(const FetchCrewMembers());
    context.read<CrewMemberTypeBloc>().add(
      const FetchCrewMemberTypes('cabin_crew'),
    );
  }

  @override
  void dispose() {
    _firstOfficerRow?.dispose();
    for (final row in _cabinCrewRows) {
      row.dispose();
    }
    super.dispose();
  }

  void _loadInitialCrew() {
    final crew = widget.initialCrew;
    if (crew == null) return;
    for (final a in crew) {
      final member = CrewMemberEntity(
        id: a.crewMemberId,
        name: a.name,
        bp: a.bp,
      );
      if (a.role == kFirstOfficerRole) {
        _firstOfficerRow = _CrewRow(role: a.role, selected: member);
      } else {
        _cabinCrewRows.add(_CrewRow(role: a.role, selected: member));
      }
    }
  }

  /// Prefills this section from a previous flight's crew (Feature 2: "keep
  /// crew from the previous flight"). Replaces whatever is currently set.
  void applyCrew(List<CrewAssignmentEntity> crew) {
    setState(() {
      _firstOfficerRow?.dispose();
      for (final row in _cabinCrewRows) {
        row.dispose();
      }
      _firstOfficerRow = null;
      _cabinCrewRows.clear();
      for (final a in crew) {
        final member = CrewMemberEntity(
          id: a.crewMemberId,
          name: a.name,
          bp: a.bp,
        );
        if (a.role == kFirstOfficerRole) {
          _firstOfficerRow = _CrewRow(role: a.role, selected: member);
        } else {
          _cabinCrewRows.add(_CrewRow(role: a.role, selected: member));
        }
      }
    });
    _notifyChange();
  }

  /// Clears every row (Feature 2: "start this flight's crew from scratch").
  void clearCrew() {
    setState(() {
      _firstOfficerRow?.dispose();
      for (final row in _cabinCrewRows) {
        row.dispose();
      }
      _firstOfficerRow = null;
      _cabinCrewRows.clear();
    });
    _notifyChange();
  }

  /// Builds the row's payload entry: an existing roster pick becomes
  /// `{crew_member_id, role}`; free-typed text (no exact roster match)
  /// becomes `{name, bp?, role}`, resolved/created by the backend at save
  /// time. Returns null for a row that's still empty.
  Map<String, String>? _payloadFor(_CrewRow row) {
    if (row.selected != null) {
      return {'crew_member_id': row.selected!.id, 'role': row.role};
    }
    final name = row.searchController.text.trim();
    if (name.isEmpty) return null;
    final bp = row.bpController.text.trim();
    return {'name': name, if (bp.isNotEmpty) 'bp': bp, 'role': row.role};
  }

  void _notifyChange() {
    final payload = <Map<String, String>>[];
    if (_firstOfficerRow != null) {
      final entry = _payloadFor(_firstOfficerRow!);
      if (entry != null) payload.add(entry);
    }
    for (final row in _cabinCrewRows) {
      final entry = _payloadFor(row);
      if (entry != null) payload.add(entry);
    }
    widget.onChanged(payload);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CrewMemberBloc, CrewMemberState>(
          listener: (context, state) {
            if (state is CrewMembersLoaded) {
              setState(() {
                _roster = state.members;
                _isLoadingRoster = false;
              });
            } else if (state is CrewMemberError) {
              setState(() => _isLoadingRoster = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
        BlocListener<CrewMemberTypeBloc, CrewMemberTypeState>(
          listener: (context, state) {
            if (state is CrewMemberTypesLoaded) {
              setState(() => _cabinCrewTypes = state.types);
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Primer Oficial (opcional)'),
          const SizedBox(height: 8),
          _buildFirstOfficerRow(),
          const SizedBox(height: 20),
          _buildLabel('Tripulación de cabina (opcional)'),
          const SizedBox(height: 8),
          ..._cabinCrewRows.map(_buildCabinCrewRow),
          const SizedBox(height: 8),
          _buildAddCabinCrewButton(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
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

  Widget _buildFirstOfficerRow() {
    _firstOfficerRow ??= _CrewRow(role: kFirstOfficerRole);
    return _buildPersonPicker(_firstOfficerRow!, showRoleDropdown: false);
  }

  Widget _buildCabinCrewRow(_CrewRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPersonPicker(row, showRoleDropdown: true)),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF6c757d), size: 20),
            tooltip: 'Quitar',
            onPressed: () {
              setState(() {
                row.dispose();
                _cabinCrewRows.remove(row);
              });
              _notifyChange();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddCabinCrewButton() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(
          () => _cabinCrewRows.add(_CrewRow(role: _defaultCabinCrewRole())),
        );
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Agregar tripulante de cabina'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4facfe),
        side: const BorderSide(color: Color(0xFF4facfe)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _defaultCabinCrewRole() {
    if (_cabinCrewTypes.isEmpty) return 'flight_attendant';
    return _roleCodeFromCatalogId(_cabinCrewTypes.first.id);
  }

  /// The backend's cabin_crew catalog uses ids like "cabin-purser" /
  /// "cabin-flight_attendant" — the suffix IS the role code this form sends.
  String _roleCodeFromCatalogId(String id) => id.replaceFirst('cabin-', '');

  Widget _buildRoleDropdown(_CrewRow row) {
    if (_cabinCrewTypes.isEmpty) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: row.role,
          isDense: true,
          items:
              _cabinCrewTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: _roleCodeFromCatalogId(t.id),
                      child: Text(
                        t.name ?? '',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => row.role = value);
            _notifyChange();
          },
        ),
      ),
    );
  }

  Widget _buildPersonPicker(_CrewRow row, {required bool showRoleDropdown}) {
    if (row.selected != null) {
      return _buildSelectedChip(row, showRoleDropdown: showRoleDropdown);
    }

    final query = row.query.toLowerCase();
    final filtered =
        query.isEmpty
            ? const <CrewMemberEntity>[]
            : _roster
                .where((m) => m.name.toLowerCase().contains(query))
                .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRoleDropdown) ...[
          _buildRoleDropdown(row),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: row.searchController,
            onChanged: (value) {
              setState(() => row.query = value);
              _notifyChange();
            },
            decoration: const InputDecoration(
              hintText: 'Nombre del tripulante',
              hintStyle: TextStyle(color: Color(0xFF6c757d), fontSize: 13),
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: Color(0xFF6c757d),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        if (row.query.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 160),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFe0e0e0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                _isLoadingRoster
                    ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                    : filtered.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Ningún tripulante guardado coincide — se guardará como nuevo',
                        style: TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 12,
                        ),
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      itemBuilder:
                          (context, index) =>
                              _buildPersonListItem(row, filtered[index]),
                    ),
          ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: row.bpController,
            keyboardType: TextInputType.number,
            onChanged: (_) => _notifyChange(),
            decoration: const InputDecoration(
              hintText: 'BP (opcional)',
              hintStyle: TextStyle(color: Color(0xFF6c757d), fontSize: 13),
              prefixIcon: Icon(
                Icons.badge_outlined,
                size: 18,
                color: Color(0xFF6c757d),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonListItem(_CrewRow row, CrewMemberEntity member) {
    return InkWell(
      onTap: () {
        setState(() {
          row.selected = member;
          row.searchController.text = member.name;
          row.bpController.text = member.bp ?? '';
          row.query = '';
        });
        _notifyChange();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFe9ecef))),
        ),
        child: Text(
          member.name,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1a1a2e)),
        ),
      ),
    );
  }

  Widget _buildSelectedChip(_CrewRow row, {required bool showRoleDropdown}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRoleDropdown) ...[
          _buildRoleDropdown(row),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.selected!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1a1a2e),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    row.selected = null;
                    row.searchController.clear();
                    row.bpController.clear();
                  });
                  _notifyChange();
                },
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF6c757d),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
