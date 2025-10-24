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
      title: 'Navegar Álbuns',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AlbumNavigatorPage(),
    );
  }
}

class AlbumNavigatorPage extends StatefulWidget {
  const AlbumNavigatorPage({super.key});

  @override
  State<AlbumNavigatorPage> createState() => _AlbumNavigatorPageState();
}

class _AlbumNavigatorPageState extends State<AlbumNavigatorPage> {
  int _currentId = 1;
  String _title = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbum();
  }

  Future<void> _fetchAlbum() async {
    setState(() {
      _isLoading = true;
      _title = '';
    });

    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/albums/$_currentId'));
    final data = jsonDecode(response.body);
    setState(() {
      _title = data['title'] ?? '';
      _isLoading = false;
    });
  }

  void _nextAlbum() {
    _currentId++;
    _fetchAlbum();
  }

  void _previousAlbum() {
    if (_currentId > 1) {
      _currentId--;
      _fetchAlbum();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navegar Álbuns')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: $_currentId',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _title.isNotEmpty)
              Text('Título: $_title',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: _currentId > 1 ? _previousAlbum : null,
                    child: const Text('Anterior')),
                ElevatedButton(
                    onPressed: _nextAlbum, child: const Text('Próximo')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
