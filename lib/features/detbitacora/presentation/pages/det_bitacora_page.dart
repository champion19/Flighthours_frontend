import 'package:flutter/material.dart';

class DetBitacoraPage extends StatelessWidget {
  final String piloto = "Cap. Juan Pérez";

  const DetBitacoraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bitácora Diaria")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Piloto: $piloto", style: Theme.of(context).textTheme.titleLarge),

            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vuelo", style: Theme.of(context).textTheme.titleMedium),
                    InfoRow("Número", "4061-BOG-CLO-AV-01/01/AA"),
                    InfoRow("Fecha salida", "1-1-24 4:20 pm"),
                    InfoRow("Matrícula", "CC-BAQ"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Datos Operacionales", style: Theme.of(context).textTheme.titleMedium),
                    InfoRow("PAX", "145"),
                    InfoRow("Tiempo de Vuelo", "1:46"),
                    InfoRow("Air", "0:34"),
                    InfoRow("Block", "1:08"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Eventos", style: Theme.of(context).textTheme.titleMedium),
                    InfoRow("Hora despegue", "1-1-24 2:15 am"),
                    InfoRow("Hora aterrizaje", "1-1-24 2:49 am"),
                    InfoRow("T/D", "1-1-24 2:54 pm"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tripulación", style: Theme.of(context).textTheme.titleMedium),
                    InfoRow("PF", "Capitán"),
                    InfoRow("PFL", "Copiloto"),
                    InfoRow("PFTO", "Capitán"),
                    InfoRow("PM", "Copiloto"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
