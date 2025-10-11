import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int contagem = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contador de carreiras para crocheteiras'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    contagem = contagem + 1;
                  });
                },
                child: const Text('Adicionar 1'),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Valor: $contagem',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
