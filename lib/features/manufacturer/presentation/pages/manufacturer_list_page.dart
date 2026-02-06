import 'package:flight_hours_app/features/manufacturer/domain/entities/manufacturer_entity.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_bloc.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_event.dart';
import 'package:flight_hours_app/features/manufacturer/presentation/bloc/manufacturer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManufacturerListPage extends StatefulWidget {
  const ManufacturerListPage({super.key});

  @override
  State<ManufacturerListPage> createState() => _ManufacturerListPageState();
}

class _ManufacturerListPageState extends State<ManufacturerListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ManufacturerBloc>().add(FetchManufacturers());
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
          'Manufacturers',
          style: TextStyle(
            color: Color(0xFF1a1a2e),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1a1a2e)),
      ),
      body: BlocBuilder<ManufacturerBloc, ManufacturerState>(
        builder: (context, state) {
          if (state is ManufacturerLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFf5576c)),
            );
          } else if (state is ManufacturerSuccess) {
            return _buildManufacturerList(state.manufacturers);
          } else if (state is ManufacturerError) {
            return _buildErrorState(state.message);
          } else {
            return const Center(
              child: Text(
                'No manufacturers found.',
                style: TextStyle(color: Color(0xFF6c757d)),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildManufacturerList(List<ManufacturerEntity> manufacturers) {
    if (manufacturers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFf5576c).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.precision_manufacturing_outlined,
                color: Color(0xFFf5576c),
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No manufacturers available',
              style: TextStyle(color: Color(0xFF6c757d), fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
          () async =>
              context.read<ManufacturerBloc>().add(FetchManufacturers()),
      color: const Color(0xFFf5576c),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: manufacturers.length,
        itemBuilder:
            (context, index) => _buildManufacturerCard(manufacturers[index]),
      ),
    );
  }

  Widget _buildManufacturerCard(ManufacturerEntity manufacturer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF212529)),
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
            // Manufacturer logo
            _buildManufacturerLogo(manufacturer.name),
            const SizedBox(width: 16),
            // Manufacturer name
            Expanded(
              child: Text(
                manufacturer.name,
                style: const TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManufacturerLogo(String name) {
    final nameLower = name.toLowerCase();

    // Check if it's Airbus or Boeing for logo images
    if (nameLower.contains('airbus')) {
      return Container(
        width: 56,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/manufacturers/Logo-Airbus.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (nameLower.contains('boeing')) {
      return Container(
        width: 56,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/manufacturers/Logo-Boeing.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Default icon for other manufacturers
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf5576c), Color(0xFFf093fb)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.precision_manufacturing,
        color: Colors.white,
        size: 24,
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
                () =>
                    context.read<ManufacturerBloc>().add(FetchManufacturers()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf5576c),
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
