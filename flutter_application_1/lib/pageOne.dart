import 'package:flutter/material.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Widgets')),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(color: Color(0xFF710000)),
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Color(0xFF09006B)),
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Color(0xFF45004D)),
              ),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(color: Color(0xFF004D05)),
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Color(0xFF4D1A00)),
              ),
              Container(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Adicione a lógica para o botão aqui
                      },
                      child: const Text('Finalizar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
