import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Primeira());
}

class Primeira extends StatelessWidget {
  const Primeira({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int contador = 0;
  double tamanhoFonte = 32;
  Color corBotao = Colors.blue;
  TextEditingController controlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregaPreferencias();
  }

  Future<void> carregaPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      contador = prefs.getInt('contador') ?? 0;
      tamanhoFonte = prefs.getDouble('tamanhoFonte') ?? 32;
      corBotao = Color(prefs.getInt('corBotao') ?? Colors.blue.value);
    });
  }

  Future<void> salvaContador(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('contador', valor);
  }

  Future<void> salvaPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('tamanhoFonte', tamanhoFonte);
    prefs.setInt('corBotao', corBotao.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador com Drawer'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Configurações',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            // ---- AJUSTAR CONTADOR ----
            ListTile(
              title: const Text('Ajustar contador'),
              subtitle: Text('Valor atual: $contador'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controlador,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Novo valor do contador',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (controlador.text.isNotEmpty) {
                    int novo = int.parse(controlador.text);
                    setState(() {
                      contador = novo;
                      salvaContador(novo);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contador atualizado!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: const Text('Salvar valor'),
              ),
            ),
            const Divider(),

            // ---- TAMANHO DA FONTE ----
            const ListTile(
              title: Text('Tamanho da fonte'),
            ),
            Slider(
              min: 16,
              max: 64,
              value: tamanhoFonte,
              onChanged: (valor) {
                setState(() {
                  tamanhoFonte = valor;
                  salvaPreferencias();
                });
              },
            ),
            Center(
              child: Text(
                'Tamanho: ${tamanhoFonte.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),

            // ---- COR DOS BOTÕES ----
            const ListTile(
              title: Text('Cor dos botões'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                children: [
                  for (Color cor in [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.orange,
                    Colors.purple
                  ])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          corBotao = cor;
                          salvaPreferencias();
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: cor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cor == corBotao
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Contagem: $contador',
              style: TextStyle(fontSize: tamanhoFonte),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: corBotao),
                  onPressed: () {
                    setState(() {
                      contador--;
                      salvaContador(contador);
                    });
                  },
                  child: const Text('Reduzir'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: corBotao),
                  onPressed: () {
                    setState(() {
                      contador++;
                      salvaContador(contador);
                    });
                  },
                  child: const Text('Aumentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
