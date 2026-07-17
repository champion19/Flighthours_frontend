import 'package:flight_hours_app/core/injector/injector.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/entities/aircraft_model_entity.dart';
import 'package:flight_hours_app/features/aircraft_model/domain/usecases/list_aircraft_model_use_case.dart';
import 'package:flight_hours_app/features/airline/domain/entities/airline_entity.dart';
import 'package:flight_hours_app/features/airline/domain/usecases/list_airline_use_case.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_bloc.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_event.dart';
import 'package:flight_hours_app/features/tail_number/presentation/bloc/tail_number_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Form to create a new tail number (aircraft registration) when a plate
/// is not found during the flight-creation flow.
///
/// Expects the [TailNumberBloc] to be provided by the caller (via
/// BlocProvider.value) so that a successful creation lands back on
/// TailNumberLookupPage as a TailNumberSuccess state.
class AddTailNumberPage extends StatefulWidget {
  final String initialPlate;

  const AddTailNumberPage({super.key, this.initialPlate = ''});

  @override
  State<AddTailNumberPage> createState() => _AddTailNumberPageState();
}

class _AddTailNumberPageState extends State<AddTailNumberPage> {
  static const _primary = Color(0xFF4facfe);
  static const _accent = Color(0xFF00f2fe);
  static const _dark = Color(0xFF1a1a2e);

  final TextEditingController _plateController = TextEditingController();

  List<AircraftModelEntity> _models = [];
  List<AirlineEntity> _airlines = [];
  String? _selectedModelId;
  String? _selectedAirlineId;

  bool _loadingLists = true;
  String? _loadError;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _plateController.text = widget.initialPlate;
    _loadLists();
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _loadLists() async {
    setState(() {
      _loadingLists = true;
      _loadError = null;
    });

    final modelResult =
        await InjectorApp.resolve<ListAircraftModelUseCase>().call();
    final airlineResult =
        await InjectorApp.resolve<ListAirlineUseCase>().call();

    if (!mounted) return;

    String? error;
    modelResult.fold((f) => error = f.message, (list) => _models = list);
    airlineResult.fold((f) => error = f.message, (list) => _airlines = list);

    setState(() {
      _loadingLists = false;
      _loadError = error;
    });
  }

  void _onSave() {
    final plate = _plateController.text.trim();

    if (plate.isEmpty || _selectedModelId == null || _selectedAirlineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _snack('Completa la matrícula, el modelo y la aerolínea.'),
      );
      return;
    }

    setState(() => _submitted = true);
    context.read<TailNumberBloc>().add(
      CreateTailNumber(
        tailNumber: plate,
        aircraftModelId: _selectedModelId!,
        airlineId: _selectedAirlineId!,
      ),
    );
  }

  SnackBar _snack(String message) => SnackBar(
    content: Text(message),
    backgroundColor: const Color(0xFFe17055),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Tail Number',
          style: TextStyle(
            color: _dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<TailNumberBloc, TailNumberState>(
        listener: (context, state) {
          if (state is TailNumberSuccess) {
            // Created successfully → back to lookup page showing the result.
            Navigator.of(context).pop();
          } else if (state is TailNumberError) {
            setState(() => _submitted = false);
            ScaffoldMessenger.of(context).showSnackBar(_snack(state.message));
          }
        },
        child: SafeArea(
          child: _loadingLists
              ? const Center(
                  child: CircularProgressIndicator(
                    color: _primary,
                    strokeWidth: 2.5,
                  ),
                )
              : _loadError != null
                  ? _buildLoadError()
                  : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildLoadError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFe17055),
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              'No se pudieron cargar las listas.\n$_loadError',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF495057), height: 1.5),
            ),
            const SizedBox(height: 20),
            TextButton(onPressed: _loadLists, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Esta matrícula no existe. Regístrala para poder usarla en el vuelo.',
            style: TextStyle(color: Color(0xFF6c757d), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),

          _label('Matrícula'),
          const SizedBox(height: 8),
          _card(
            child: TextField(
              controller: _plateController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 7,
              inputFormatters: [
                // Letters, digits and hyphens (backend requires ^[A-Z0-9-]+$)
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\-]')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.toUpperCase(),
                  ),
                ),
              ],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _dark,
              ),
              decoration: const InputDecoration(
                counterText: '',
                hintText: 'e.g. HK-1333',
                hintStyle: TextStyle(
                  color: Color(0xFFadb5bd),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(Icons.flight, color: _primary),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _label('Modelo de aeronave'),
          const SizedBox(height: 8),
          _card(
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedModelId,
                  hint: const Text('Selecciona un modelo'),
                  icon: const Icon(Icons.arrow_drop_down, color: _primary),
                  items: _models
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(m.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedModelId = v),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _label('Aerolínea'),
          const SizedBox(height: 8),
          _card(
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedAirlineId,
                  hint: const Text('Selecciona una aerolínea'),
                  icon: const Icon(Icons.arrow_drop_down, color: _primary),
                  items: _airlines
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(a.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAirlineId = v),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitted ? null : _onSave,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: _submitted
                      ? null
                      : const LinearGradient(colors: [_primary, _accent]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: _submitted
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Guardar matrícula',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      color: _dark,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _card({required Widget child}) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}
