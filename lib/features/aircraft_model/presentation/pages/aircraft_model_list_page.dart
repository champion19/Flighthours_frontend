import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_bloc.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_event.dart';
import 'package:flight_hours_app/features/aircraft_model/presentation/bloc/aircraft_model_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AircraftModelListPage extends StatefulWidget {
  const AircraftModelListPage({super.key});

  @override
  State<AircraftModelListPage> createState() => _AircraftModelListPageState();
}

class _AircraftModelListPageState extends State<AircraftModelListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AircraftModelBloc>().add(FetchAircraftModels());
  }

  void _showStatusUpdateResult(
    BuildContext context,
    String message,
    bool isSuccess,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? const Color(0xFF00b894) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    context.read<AircraftModelBloc>().add(FetchAircraftModels());
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
          'Aircraft Models',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1a1a2e)),
      ),
      body: BlocConsumer<AircraftModelBloc, AircraftModelState>(
        listener: (context, state) {
          if (state is AircraftModelStatusUpdateSuccess) {
            _showStatusUpdateResult(
              context,
              'Aircraft model ${state.isActivation ? "activated" : "deactivated"} successfully',
              true,
            );
          } else if (state is AircraftModelError) {
            _showStatusUpdateResult(context, state.message, false);
          }
        },
        builder: (context, state) {
          if (state is AircraftModelLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF667eea)),
            );
          } else if (state is AircraftModelSuccess) {
            return _buildAircraftModelList(state.aircraftModels);
          } else if (state is AircraftModelError) {
            return _buildErrorState(state.message);
          } else {
            return const Center(
              child: Text(
                'No aircraft models found.',
                style: TextStyle(color: Color(0xFF6c757d)),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAircraftModelList(List<AircraftModelEntity> aircraftModels) {
    return RefreshIndicator(
      onRefresh:
          () async =>
              context.read<AircraftModelBloc>().add(FetchAircraftModels()),
      color: const Color(0xFF667eea),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: aircraftModels.length,
        itemBuilder:
            (context, index) => _buildAircraftModelCard(aircraftModels[index]),
      ),
    );
  }

  Widget _buildAircraftModelCard(AircraftModelEntity model) {
    final isActive = model.status == 'active' || model.status == '1';
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
              child: const Icon(
                Icons.airplanemode_active,
                color: Colors.white,
                size: 24,
              ),
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
                          model.name,
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
                          isActive ? 'Active' : 'Inactive',
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (model.family != null && model.family!.isNotEmpty) ...[
                        Text(
                          model.family!,
                          style: const TextStyle(
                            color: Color(0xFF6c757d),
                            fontSize: 13,
                          ),
                        ),
                        if (model.aircraftTypeName != null &&
                            model.aircraftTypeName!.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '·',
                              style: TextStyle(
                                color: Color(0xFF6c757d),
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                      if (model.aircraftTypeName != null &&
                          model.aircraftTypeName!.isNotEmpty) ...[
                        const Icon(
                          Icons.flight,
                          size: 14,
                          color: Color(0xFF6c757d),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          model.aircraftTypeName!,
                          style: const TextStyle(
                            color: Color(0xFF6c757d),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (model.engineName != null && model.engineName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        model.engineName!,
                        style: const TextStyle(
                          color: Color(0xFF6c757d),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildToggleButton(model, isActive),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6c757d)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Color(0xFF6c757d), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(AircraftModelEntity model, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            () =>
                isActive
                    ? _showDeactivateConfirmation(model)
                    : _showActivateConfirmation(model),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                isActive
                    ? const Color(0xFFe17055).withValues(alpha: 0.1)
                    : const Color(0xFF00b894).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isActive
                      ? const Color(0xFFe17055).withValues(alpha: 0.3)
                      : const Color(0xFF00b894).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.cancel_outlined : Icons.check_circle_outline,
                color:
                    isActive
                        ? const Color(0xFFe17055)
                        : const Color(0xFF00b894),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isActive ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color:
                      isActive
                          ? const Color(0xFFe17055)
                          : const Color(0xFF00b894),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActivateConfirmation(AircraftModelEntity model) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Activate Aircraft Model',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to activate "${model.name}"?',
              style: const TextStyle(color: Color(0xFF6c757d)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6c757d)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AircraftModelBloc>().add(
                    ActivateAircraftModel(aircraftModelId: model.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00b894),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Activate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeactivateConfirmation(AircraftModelEntity model) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Deactivate Aircraft Model',
              style: TextStyle(
                color: Color(0xFF1a1a2e),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to deactivate "${model.name}"?',
                  style: const TextStyle(color: Color(0xFF6c757d)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffeaa7).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFfdcb6e)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Color(0xFFe17055),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This aircraft model will not be available for flights.',
                          style: TextStyle(
                            color: Color(0xFF1a1a2e),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color(0xFF6c757d)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AircraftModelBloc>().add(
                    DeactivateAircraftModel(aircraftModelId: model.id),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFe17055),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Deactivate',
                  style: TextStyle(color: Colors.white),
                ),
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
            onPressed:
                () => context.read<AircraftModelBloc>().add(
                  FetchAircraftModels(),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
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
