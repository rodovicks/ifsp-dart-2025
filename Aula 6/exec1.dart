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
      int corValor = prefs.getInt('corBotao') ?? Colors.blue.value;
      corBotao = Color(corValor);
    });
  }

  Future<void> salvaContador(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('contador', valor);
  }

  Future<void> atualizaEstilo(double fonte, Color cor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('tamanhoFonte', fonte);
    prefs.setInt('corBotao', cor.value);

    setState(() {
      tamanhoFonte = fonte;
      corBotao = cor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador principal'),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: corBotao),
              onPressed: () {
                abreAjusteContador(context);
              },
              child: const Text('Ajustar contador'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: corBotao),
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute<Map<String, dynamic>>(
                    builder: (context) => ConfiguracoesPage(
                      fonteInicial: tamanhoFonte,
                      corInicial: corBotao,
                    ),
                  ),
                );

                if (resultado != null) {
                  atualizaEstilo(resultado['fonte'] ?? tamanhoFonte,
                      resultado['cor'] ?? corBotao);
                }
              },
              child: const Text('Configurações'),
            ),
          ],
        ),
      ),
    );
  }

  void abreAjusteContador(BuildContext context) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute<int>(
        builder: (context) => const AjusteContador(),
      ),
    );

    if (resultado != null) {
      setState(() {
        contador = resultado;
      });
    }
  }
}

class AjusteContador extends StatefulWidget {
  const AjusteContador({super.key});

  @override
  State<AjusteContador> createState() => _AjusteContadorState();
}

class _AjusteContadorState extends State<AjusteContador> {
  int contador = 0;
  TextEditingController controlador = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregaContador();
  }

  Future<void> carregaContador() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      contador = prefs.getInt('contador') ?? 0;
    });
  }

  Future<void> salvaContador(int valor) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('contador', valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuste do contador'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Valor atual: $contador',
                style: const TextStyle(fontSize: 32)),
            TextField(
              controller: controlador,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Novo valor'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controlador.text.isNotEmpty) {
                  int valor = int.parse(controlador.text);
                  salvaContador(valor);
                  Navigator.pop(context, valor);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfiguracoesPage extends StatefulWidget {
  final double fonteInicial;
  final Color corInicial;

  const ConfiguracoesPage({
    super.key,
    required this.fonteInicial,
    required this.corInicial,
  });

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  double tamanhoFonte = 32;
  Color corSelecionada = Colors.blue;

  @override
  void initState() {
    super.initState();
    tamanhoFonte = widget.fonteInicial;
    corSelecionada = widget.corInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Tamanho da fonte: ${tamanhoFonte.toStringAsFixed(0)}',
                style: TextStyle(fontSize: tamanhoFonte)),
            Slider(
              min: 16,
              max: 64,
              value: tamanhoFonte,
              onChanged: (valor) {
                setState(() {
                  tamanhoFonte = valor;
                });
              },
            ),
            const Text('Cor dos botões:'),
            Wrap(
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
                        corSelecionada = cor;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cor == corSelecionada
                              ? Colors.black
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: corSelecionada),
              onPressed: () {
                Navigator.pop(context, {
                  'fonte': tamanhoFonte,
                  'cor': corSelecionada,
                });
              },
              child: const Text('Salvar configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
