import 'package:flight_hours_app/features/crew_member_type/domain/entities/crew_member_type_entity.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_bloc.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_event.dart';
import 'package:flight_hours_app/features/crew_member_type/presentation/bloc/crew_member_type_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrewMemberTypeListPage extends StatefulWidget {
  const CrewMemberTypeListPage({super.key});

  @override
  State<CrewMemberTypeListPage> createState() => _CrewMemberTypeListPageState();
}

class _CrewMemberTypeListPageState extends State<CrewMemberTypeListPage> {
  String _selectedRole = 'pilot';

  final List<Map<String, String>> _roles = [
    {'value': 'pilot', 'label': 'Pilot'},
    {'value': 'copilot', 'label': 'Copilot'},
    {'value': 'flight_engineer', 'label': 'Flight Engineer'},
    {'value': 'cabin_crew', 'label': 'Cabin Crew'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<CrewMemberTypeBloc>().add(FetchCrewMemberTypes(_selectedRole));
  }

  void _onRoleChanged(String? role) {
    if (role != null && role != _selectedRole) {
      setState(() => _selectedRole = role);
      context.read<CrewMemberTypeBloc>().add(FetchCrewMemberTypes(role));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Crew Member Types',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1a1a2e)),
      ),
      body: Column(
        children: [
          _buildRoleSelector(),
          Expanded(
            child: BlocConsumer<CrewMemberTypeBloc, CrewMemberTypeState>(
              listener: (context, state) {
                if (state is CrewMemberTypeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CrewMemberTypeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFf093fb)),
                  );
                } else if (state is CrewMemberTypesLoaded) {
                  if (state.types.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildTypeList(state.types);
                } else if (state is CrewMemberTypeError) {
                  return _buildErrorState(state.message);
                } else {
                  return const Center(
                    child: Text(
                      'Select a role to view crew member types',
                      style: TextStyle(color: Color(0xFF6c757d)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFe9ecef), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'Role:',
            style: TextStyle(
              color: Color(0xFF6c757d),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFf8f9fa),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFe9ecef)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF667eea),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  items:
                      _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role['value'],
                              child: Text(role['label']!),
                            ),
                          )
                          .toList(),
                  onChanged: _onRoleChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeList(List<CrewMemberTypeEntity> types) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CrewMemberTypeBloc>().add(
          FetchCrewMemberTypes(_selectedRole),
        );
      },
      color: const Color(0xFFf093fb),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: types.length,
        itemBuilder: (context, index) => _buildTypeCard(types[index]),
      ),
    );
  }

  Widget _buildTypeCard(CrewMemberTypeEntity type) {
    final isActive = type.isActive;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF212529) : const Color(0xFFdee2e6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isActive
                          ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                          : [const Color(0xFFadb5bd), const Color(0xFFced4da)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.badge, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.name ?? 'Unknown',
                          style: TextStyle(
                            color:
                                isActive
                                    ? const Color(0xFF1a1a2e)
                                    : const Color(0xFF6c757d),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? const Color(
                                    0xFF00b894,
                                  ).withValues(alpha: 0.1)
                                  : const Color(
                                    0xFFe17055,
                                  ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          type.displayStatus,
                          style: TextStyle(
                            color:
                                isActive
                                    ? const Color(0xFF00b894)
                                    : const Color(0xFFe17055),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (type.description != null && type.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        type.description!,
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF667eea).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.people_outline,
              color: Color(0xFF667eea),
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No crew member types found for this role',
            style: TextStyle(color: Color(0xFF6c757d)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Color(0xFF6c757d)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CrewMemberTypeBloc>().add(
                FetchCrewMemberTypes(_selectedRole),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf093fb),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
