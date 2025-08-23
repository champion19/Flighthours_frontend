
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_bloc.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_event.dart';
import 'package:flight_hours_app/features/airline/presentation/bloc/airline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirlineListPage extends StatefulWidget {
  const AirlineListPage({super.key});

  @override
  State<AirlineListPage> createState() => _AirlineListPageState();
}

class _AirlineListPageState extends State<AirlineListPage> {
  @override
  void initState() {
    super.initState();
    context.read<AirlineBloc>().add(FetchAirlines());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airlines'),
      ),
      body: BlocBuilder<AirlineBloc, AirlineState>(
        builder: (context, state) {
          if (state is AirlineLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AirlineSuccess) {
            return ListView.builder(
              itemCount: state.airlines.length,
              itemBuilder: (context, index) {
                final airline = state.airlines[index];
                return ListTile(
                  title: Text(airline.name),
                );
              },
            );
          } else if (state is AirlineError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('No airlines found.'),
            );
          }
        },
      ),
    );
  }
}
