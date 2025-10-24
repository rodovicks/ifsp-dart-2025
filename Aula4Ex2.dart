import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotação do Dólar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DollarRatePage(),
    );
  }
}

class DollarRatePage extends StatefulWidget {
  const DollarRatePage({super.key});

  @override
  State<DollarRatePage> createState() => _DollarRatePageState();
}

class _DollarRatePageState extends State<DollarRatePage> {
  String _high = '';
  String _low = '';
  bool _isLoading = false;

  Future<void> _fetchDollarRate() async {
    setState(() {
      _isLoading = true;
      _high = '';
      _low = '';
    });

    try {
      final url = Uri.parse('https://economia.awesomeapi.com.br/last/USD-BRL');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final usd = data['USDBRL'];
        setState(() {
          _high = usd['high'];
          _low = usd['low'];
        });
      }
    } catch (e) {
      setState(() {
        _high = 'Erro';
        _low = 'Erro';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotação do Dólar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchDollarRate,
              child: const Text('Verificar'),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _high.isNotEmpty && _low.isNotEmpty) ...[
              Text('Maior cotação: $_high',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Menor cotação: $_low',
                  style: const TextStyle(fontSize: 18)),
            ],
          ],
        ),
      ),
    );
  }
}
