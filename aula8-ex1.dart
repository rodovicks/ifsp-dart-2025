import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn English with Wikipedia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/text': (context) => TextScreen(),
        '/words': (context) => WordsScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  void fetchWikipediaContent() {
    final link = controller.text;
    if (link.isNotEmpty) {
      Navigator.pushNamed(context, '/text', arguments: link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn English with Wikipedia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Enter Wikipedia URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWikipediaContent,
              child: Text('Fetch Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/words');
              },
              child: Text('View Understood Words'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextScreen extends StatefulWidget {
  @override
  TextScreenState createState() => TextScreenState();
}

class TextScreenState extends State<TextScreen> {
  String firstParagraph = '';
  List<String> words = [];

  /// Lista compartilhada com WordsScreen
  static Set<String> understoodWords = {};

  @override
  void initState() {
    super.initState();
    fetchWikipediaContent();
  }

  Future<void> fetchWikipediaContent() async {
    final link = ModalRoute.of(context)!.settings.arguments as String;
    final response = await http.get(Uri.parse(link));

    if (response.statusCode == 200) {
      final document = parse(response.body);
      final content = document.querySelector('div.mw-parser-output');
      final paragraph = content?.querySelectorAll('p').first.text ?? '';

      setState(() {
        firstParagraph = paragraph;
        words = paragraph.split(RegExp(r"\s+")).toList();
      });
    } else {
      throw Exception('Failed to load Wikipedia page');
    }
  }

  void fetchDefinition(String word) async {
    final response = await http.get(
      Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final definition = data[0]['meanings'][0]['definitions'][0]['definition'];
      final audioUrl = data[0]['phonetics'][0]['audio'] ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DefinitionPage(
            word: word,
            definition: definition,
            audioUrl: audioUrl,
            onUnderstand: () {
              setState(() {
                TextScreenState.understoodWords.add(word);
              });
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      // Nothing for now
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text from Wikipedia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(firstParagraph),
            SizedBox(height: 20),
            Wrap(
              children: words.map((word) {
                final cleanWord = word.replaceAll(RegExp(r'[^\w\-]'), '');

                if (cleanWord.isEmpty) return SizedBox();

                /// Se já foi compreendida
                if (TextScreenState.understoodWords.contains(cleanWord)) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      cleanWord,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => fetchDefinition(cleanWord),
                    child: Text(cleanWord),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class DefinitionPage extends StatelessWidget {
  final String word;
  final String definition;
  final String audioUrl;
  final VoidCallback onUnderstand;

  /// campo público (não usa _ )
  final AudioPlayer audioPlayer = AudioPlayer();

  DefinitionPage({
    required this.word,
    required this.definition,
    required this.audioUrl,
    required this.onUnderstand,
  });

  void playAudio() async {
    if (audioUrl.isNotEmpty) {
      await audioPlayer.play(audioUrl); // <-- versão correta
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(word)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Definition:\n$definition'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: playAudio,
              child: Text('Play Pronunciation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onUnderstand,
              child: Text('I Understand'),
            ),
          ],
        ),
      ),
    );
  }
}

class WordsScreen extends StatefulWidget {
  @override
  WordsScreenState createState() => WordsScreenState();
}

class WordsScreenState extends State<WordsScreen> {
  @override
  Widget build(BuildContext context) {
    final words = TextScreenState.understoodWords;

    return Scaffold(
      appBar: AppBar(title: Text('Understood Words')),
      body: ListView(
        children: words.map((word) {
          return ListTile(
            title: Text(word),
            trailing: IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  words.remove(word);
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
