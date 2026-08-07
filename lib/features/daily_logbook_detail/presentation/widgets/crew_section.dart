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

/// Legacy role value from before the "Tripulación de Mando" redesign — old
/// flights may still have a row saved with this. Treated as a command crew
/// row on load (normalized to [kDefaultCommandCrewRole]); no longer written.
const String kLegacyFirstOfficerRole = 'first_officer';

/// The 5 command crew role values — same vocabulary as the per-flight Crew
/// Role field (`daily_logbook_detail.crew_role`). Kept in sync with
/// `_crewRoles` in `daily_logbook_detail_page.dart`.
const List<String> kCommandCrewRoles = [
  'captain',
  'first officer',
  'instructor',
  'line check captain',
  'safety pilot',
];

const String kDefaultCommandCrewRole = 'first officer';

bool _isCommandCrewRole(String role) =>
    role == kLegacyFirstOfficerRole || kCommandCrewRoles.contains(role);

/// One row in the crew section: either a "Tripulación de Mando" row (role
/// pickable from the 5 crew_role values) or a "Tripulación de cabina" row
/// (role pickable from the cabin_crew catalog). A row is either resolved to
/// an existing roster member ([selected] set, picked from search) or holds a
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

/// Optional "Tripulación" section for the Daily Logbook Detail form:
/// Tripulación de Mando (0-N, realistically 2-4) + Tripulación de cabina
/// (0-N). Each row just needs a name (typed or picked from a search
/// suggestion) + role — nothing is sent to the backend until the whole
/// flight is saved, at which point every row (existing people and brand-new
/// ones alike) is persisted together in one request via [onChanged]'s
/// payload (`crew_member_id` for existing people, `name`/`bp` for new ones —
/// resolved server-side in the same transaction).
class CrewSection extends StatefulWidget {
  final List<CrewAssignmentEntity>? initialCrew;
  final ValueChanged<List<Map<String, String>>> onChanged;

  const CrewSection({super.key, this.initialCrew, required this.onChanged});

  @override
  State<CrewSection> createState() => CrewSectionState();
}

class CrewSectionState extends State<CrewSection> {
  final List<_CrewRow> _commandCrewRows = [];
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
    for (final row in _commandCrewRows) {
      row.dispose();
    }
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
      final role =
          a.role == kLegacyFirstOfficerRole ? kDefaultCommandCrewRole : a.role;
      if (_isCommandCrewRole(role)) {
        _commandCrewRows.add(_CrewRow(role: role, selected: member));
      } else {
        _cabinCrewRows.add(_CrewRow(role: role, selected: member));
      }
    }
  }

  /// Prefills this section from a previous flight's crew (Feature 2: "keep
  /// crew from the previous flight"). Replaces whatever is currently set.
  void applyCrew(List<CrewAssignmentEntity> crew) {
    setState(() {
      for (final row in _commandCrewRows) {
        row.dispose();
      }
      for (final row in _cabinCrewRows) {
        row.dispose();
      }
      _commandCrewRows.clear();
      _cabinCrewRows.clear();
      for (final a in crew) {
        final member = CrewMemberEntity(
          id: a.crewMemberId,
          name: a.name,
          bp: a.bp,
        );
        final role =
            a.role == kLegacyFirstOfficerRole
                ? kDefaultCommandCrewRole
                : a.role;
        if (_isCommandCrewRole(role)) {
          _commandCrewRows.add(_CrewRow(role: role, selected: member));
        } else {
          _cabinCrewRows.add(_CrewRow(role: role, selected: member));
        }
      }
    });
    _notifyChange();
  }

  /// Clears every row (Feature 2: "start this flight's crew from scratch").
  void clearCrew() {
    setState(() {
      for (final row in _commandCrewRows) {
        row.dispose();
      }
      for (final row in _cabinCrewRows) {
        row.dispose();
      }
      _commandCrewRows.clear();
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
    for (final row in _commandCrewRows) {
      final entry = _payloadFor(row);
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
            } else if (state is CrewMemberCreated) {
              // A row's BP was just filled in on the roster (see _saveBpForRow) —
              // reflect it on the matching row(s) so the field switches from
              // editable to the read-only display.
              setState(() {
                _roster = state.members;
                for (final row in [..._commandCrewRows, ..._cabinCrewRows]) {
                  if (row.selected?.id == state.member.id) {
                    row.selected = state.member;
                  }
                }
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
          _buildLabel('Tripulación de Mando (opcional)'),
          const SizedBox(height: 8),
          ..._commandCrewRows.map(_buildCommandCrewRow),
          const SizedBox(height: 8),
          _buildAddCommandCrewButton(),
          if (_buildCommandCrewCountWarning() != null)
            _buildCommandCrewCountWarning()!,
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

  /// Non-blocking hint shown when the command crew count falls outside the
  /// realistic range the client described. This list is the OTHER pilots —
  /// it does not include the bitácora's own owner (whoever picked a role in
  /// the Crew Role field above). Total aircraft crew is 2-4, so this list
  /// should realistically hold 1-3 people, not 2-4. Never prevents saving.
  Widget? _buildCommandCrewCountWarning() {
    final count = _commandCrewRows.length;
    if (count == 0 || count <= 3) return null;
    const message =
        'Se registraron más de 3 tripulantes de mando adicionales al titular de la bitácora — verifica que sea correcto.';
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 14, color: Color(0xFFf0a020)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFf0a020), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandCrewRow(_CrewRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPersonPicker(
              row,
              roleDropdownBuilder: _buildCommandRoleDropdown,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF6c757d), size: 20),
            tooltip: 'Quitar',
            onPressed: () {
              setState(() {
                row.dispose();
                _commandCrewRows.remove(row);
              });
              _notifyChange();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommandCrewButton() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(
          () => _commandCrewRows.add(_CrewRow(role: kDefaultCommandCrewRole)),
        );
      },
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Agregar tripulante de mando'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4facfe),
        side: const BorderSide(color: Color(0xFF4facfe)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCommandRoleDropdown(_CrewRow row) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: kCommandCrewRoles.contains(row.role) ? row.role : null,
          isDense: true,
          items:
              kCommandCrewRoles
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(r, style: const TextStyle(fontSize: 13)),
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

  Widget _buildCabinCrewRow(_CrewRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPersonPicker(
              row,
              roleDropdownBuilder: _buildCabinRoleDropdown,
            ),
          ),
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

  Widget _buildCabinRoleDropdown(_CrewRow row) {
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

  Widget _buildPersonPicker(
    _CrewRow row, {
    required Widget Function(_CrewRow row) roleDropdownBuilder,
  }) {
    if (row.selected != null) {
      return _buildSelectedChip(row, roleDropdownBuilder: roleDropdownBuilder);
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
        roleDropdownBuilder(row),
        const SizedBox(height: 8),
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

  Widget _buildSelectedChip(
    _CrewRow row, {
    required Widget Function(_CrewRow row) roleDropdownBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        roleDropdownBuilder(row),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              const SizedBox(height: 6),
              _buildSelectedBp(row),
            ],
          ),
        ),
      ],
    );
  }

  /// BP for an already-picked roster member: read-only display if it's on
  /// record; an inline editable field if not, saved to the roster (not the
  /// flight) as soon as the field loses focus — see [_saveBpForRow].
  Widget _buildSelectedBp(_CrewRow row) {
    final bp = row.selected!.bp;
    if (bp != null && bp.isNotEmpty) {
      return Row(
        children: [
          const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF6c757d)),
          const SizedBox(width: 4),
          Text(
            'BP: $bp',
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 12),
          ),
        ],
      );
    }
    return Row(
      children: [
        const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF6c757d)),
        const SizedBox(width: 4),
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) _saveBpForRow(row);
            },
            child: TextField(
              controller: row.bpController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _saveBpForRow(row),
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                isDense: true,
                isCollapsed: true,
                hintText: 'BP (agregar)',
                hintStyle: TextStyle(color: Color(0xFF6c757d), fontSize: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Persists a BP typed for an already-picked roster member who didn't have
  /// one — reuses the roster's add-crew-member endpoint, which fills bp in
  /// only when the matched person doesn't already have one on record.
  void _saveBpForRow(_CrewRow row) {
    final member = row.selected;
    if (member == null) return;
    final bp = row.bpController.text.trim();
    if (bp.isEmpty || bp == member.bp) return;
    context.read<CrewMemberBloc>().add(CreateCrewMember(member.name, bp: bp));
  }
}
