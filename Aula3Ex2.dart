import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CombustivelApp());
}

class CombustivelApp extends StatelessWidget {
  const CombustivelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cálculo de Consumo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const ConsumoPage(),
    );
  }
}

class ConsumoPage extends StatefulWidget {
  const ConsumoPage({super.key});

  @override
  State<ConsumoPage> createState() => _ConsumoPageState();
}

class _ConsumoPageState extends State<ConsumoPage> {
  final _kmController = TextEditingController();
  final _litrosController = TextEditingController();

  final List<Map<String, dynamic>> _resultados = [];

  void _calcularConsumo() {
    final km = double.tryParse(_kmController.text);
    final litros = double.tryParse(_litrosController.text);

    if (km == null || litros == null || litros <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe valores válidos!')),
      );
      return;
    }

    final consumo = km / litros;
    final data = DateFormat('dd/MM/yyyy').format(DateTime.now());

    setState(() {
      _resultados.insert(0, {
        'data': data,
        'consumo': consumo,
      });
      _kmController.clear();
      _litrosController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de Combustível'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Km rodados',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _litrosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Litros gastos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _calcularConsumo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Calcular Consumo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _resultados.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum cálculo ainda.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final item = _resultados[index];
                        return ListTile(
                          leading: const Icon(Icons.local_gas_station_rounded,
                              color: Colors.deepPurple),
                          title: Text(
                            '${item['data']}  ${item['consumo'].toStringAsFixed(1)} km/l',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
