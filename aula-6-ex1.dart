import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Calculadora());
  }
}

enum Operacoes { igual, soma, sub, multi, div }

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String tela = "0";
  String operando1 = "";
  String operando2 = "";
  Operacoes operador = Operacoes.igual;
  bool repetir = false;

  double memoria = 0.0;

  late Database database;

  @override
  void initState() {
    super.initState();
    iniciaDB();
  }

  Future<void> iniciaDB() async {
    WidgetsFlutterBinding.ensureInitialized();

    database = await openDatabase(
      join(await getDatabasesPath(), 'calc.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE calculadora(id INTEGER PRIMARY KEY, tela TEXT)');
        await db.insert('calculadora', {'id': 1, 'tela': "0"});
      },
    );

    iniciaTela();
  }

  Future<void> iniciaTela() async {
    final valor = await retornaTela();
    setState(() => tela = valor);
  }

  Future<String> retornaTela() async {
    final db = database;
    final result = await db.query('calculadora', where: "id = 1");
    return result.first['tela'] as String;
  }

  void salvaTela(String valor) async {
    final db = database;
    await db.update('calculadora', {'tela': valor}, where: 'id = 1');
  }

  // ------------------------------------------------------------------------------------
  // FUNÇÕES DE CÁLCULO
  // ------------------------------------------------------------------------------------

  void processarOperacao(Operacoes op) {
    operando1 = tela;
    operador = op;
    repetir = false;
    setState(() => tela = "");
  }

  void calcular() {
    if (repetir) {
      operando1 = tela;
    } else {
      operando2 = tela;
    }

    double n1 = double.tryParse(operando1) ?? 0;
    double n2 = double.tryParse(operando2) ?? 0;
    double resultado = 0;

    switch (operador) {
      case Operacoes.soma:
        resultado = n1 + n2;
        break;
      case Operacoes.sub:
        resultado = n1 - n2;
        break;
      case Operacoes.multi:
        resultado = n1 * n2;
        break;
      case Operacoes.div:
        if (n2 == 0) {
          tela = "Erro";
          salvaTela(tela);
          return;
        }
        resultado = n1 / n2;
        break;
      default:
        break;
    }

    setState(() => tela = removerZeros(resultado.toString()));
    salvaTela(tela);
    repetir = true;
  }

  String removerZeros(String valor) {
    if (valor.contains('.')) {
      valor = valor.replaceAll(RegExp(r'0+$'), '');
      valor = valor.replaceAll(RegExp(r'\.$'), '');
    }
    return valor;
  }

  // ------------------------------------------------------------------------------------
  // BOTÕES (widgets reutilizáveis)
  // ------------------------------------------------------------------------------------

  Widget botao(String texto, VoidCallback acao, {double largura = 70}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: largura,
        height: 55,
        child: ElevatedButton(onPressed: acao, child: Text(texto)),
      ),
    );
  }

  Widget botaoNumero(String n) {
    return botao(n, () {
      setState(() {
        if (tela == "0") {
          tela = n;
        } else {
          tela += n;
        }
      });
      salvaTela(tela);
    });
  }

  Widget botaoOper(String simbolo, Operacoes op) {
    return botao(simbolo, () => processarOperacao(op));
  }

  // ------------------------------------------------------------------------------------
  // INTERFACE
  // ------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerRight,
            child: Text(
              tela,
              style: TextStyle(fontSize: 48),
            ),
          ),

          // Linha AC / MRC / M+ / M-
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botao("AC", () {
                setState(() => tela = "0");
                salvaTela(tela);
              }),
              botao("MRC", () {
                setState(() {
                  tela = removerZeros(memoria.toString());
                  memoria = 0;
                });
                salvaTela(tela);
              }),
              botao("M+", () {
                memoria += double.tryParse(tela) ?? 0;
              }),
              botao("M-", () {
                memoria -= double.tryParse(tela) ?? 0;
              }),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botaoNumero("7"),
              botaoNumero("8"),
              botaoNumero("9"),
              botaoOper("/", Operacoes.div),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botaoNumero("4"),
              botaoNumero("5"),
              botaoNumero("6"),
              botaoOper("*", Operacoes.multi),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botaoNumero("1"),
              botaoNumero("2"),
              botaoNumero("3"),
              botaoOper("-", Operacoes.sub),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              botao("0", () {
                if (tela != "0") {
                  setState(() => tela += "0");
                  salvaTela(tela);
                }
              }, largura: 90),
              botao(".", () {
                if (!tela.contains(".")) {
                  setState(() => tela += ".");
                  salvaTela(tela);
                }
              }),
              botao("=", () => calcular()),
              botaoOper("+", Operacoes.soma),
            ],
          ),
        ],
      ),
    );
  }
}
