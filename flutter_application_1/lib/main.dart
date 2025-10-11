import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
                height: 200,
                decoration: BoxDecoration(color: Color(0xFF710000)),
              ),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(color: Color(0xFF01544F)),
              ),
              Container(
                width: double.infinity,
                height: 210,
                decoration: BoxDecoration(color: Color(0xFF4D1A00)),
              ),
              Container(
                width: double.infinity,
                height: 210,
                decoration: BoxDecoration(color: Color(0xFFFFA726)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
